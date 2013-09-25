Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3IYNMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:12:35 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50153 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306Ab3IYNMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:12:34 -0400
Date: Wed, 25 Sep 2013 14:12:30 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bart Kuivenhoven <bemk@redhat.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jcm@redhat.com, msalter@redhat.com
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
Message-ID: <20130925131230.GL21381@console-pimps.org>
References: <1379929528-7534-1-git-send-email-bemk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379929528-7534-1-git-send-email-bemk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep, at 11:45:28AM, Bart Kuivenhoven wrote:
> The problem in efi_main was that the idt was cleared before the
> interrupts were disabled.
> 
> The UEFI spec states that interrupts aren't used so this shouldn't be
> too much of a problem. Peripherals however don't necessarily know about
> this and thus might cause interrupts to happen anyway. Even if
> ExitBootServices() has been called.
> 
> This means there is a risk of an interrupt being triggered while the IDT
> register is nullified and the interrupt bit hasn't been cleared,
> allowing for a triple fault.
> 
> This patch disables the interrupt flag, while leaving the existing IDT
> in place. The CPU won't care about the IDT at all as long as the
> interrupt bit is off, so it's safe to leave it in place as nothing will
> ever happen to it.
> 
> Signed-off-by: Bart Kuivenhoven <bemk@redhat.com>
> ---
>  arch/x86/boot/compressed/eboot.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)

Applied, thanks Bart!

-- 
Matt Fleming, Intel Open Source Technology Center
