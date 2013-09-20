Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab3ITP3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:29:09 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49817 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737Ab3ITP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:29:07 -0400
Date: Fri, 20 Sep 2013 16:28:59 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bart Kuivenhoven <bemk@redhat.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jcm@redhat.com, msalter@redhat.com
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
Message-ID: <20130920152859.GC21381@console-pimps.org>
References: <1379525333-4373-1-git-send-email-bemk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379525333-4373-1-git-send-email-bemk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep, at 07:28:53PM, Bart Kuivenhoven wrote:
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

Just to be clear, you haven't witnessed a triple fault, correct?

> This patch fixes this by clearing the interrupt bit before the lidt
> instruction.

I think we can go even further than this and get rid of all of the IDT
code in the EFI boot stub. The kernel maintains its own IDT anyway.

-- 
Matt Fleming, Intel Open Source Technology Center
