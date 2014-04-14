Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaDNJeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:34:25 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46528 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562AbaDNJeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:34:01 -0400
Date: Mon, 14 Apr 2014 10:33:32 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi: Clarify Kconfig help for EFI_MIXED
Message-ID: <20140414093332.GA10956@console-pimps.org>
References: <1397239154-30121-1-git-send-email-thomas@archlinux.org>
 <53482E61.8050606@zytor.com>
 <20140411184433.GA15344@console-pimps.org>
 <20140414071534.GA19501@gmail.com>
 <534B9C12.4050708@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <534B9C12.4050708@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr, at 10:28:02AM, Thomas Bächler wrote:
> Am 14.04.2014 09:15, schrieb Ingo Molnar:
> >>> Right, it is really that it is not possible to boot a mixed-mode kernel
> >>> on its non-native firmware using the stub, since the stub itself can
> >>> only be one way or the other.
> >>
> >> Yeah, my help text was a bit... unhelpful.
> >>
> >> CONFIG_EFI_MIXED does not introduce a regression of any sort, you can
> >> enable it without worrying about that.
> >>
> >> All the boot configurations that used to work will continue to work.
> >>
> >> What I meant to say was that it isn't possible to use the EFI mixed 
> >> *feature* (booting a 64-bit kernel with 32-bit firmware) with the 
> >> EFI boot stub - so you can build support into your kernel but 
> >> there's no way to make the CPU actually execute those code paths.
> > 
> > Same goes for booting a 32-bit kernel on 64-bit firmware, right?
> > 
> 
> It seems that isn't implemented:
> 
> config EFI_MIXED
>         bool "EFI mixed-mode support"
>         depends on EFI_STUB && X86_64
> 

Correct, since that would require translating 64-bit pointers from the
firmware into 32-bit pointers for the kernel, which isn't as straight
forward as the 32-bit firmware / 64-bit kernel case, i.e. ensure all
allocations are < 4GB and truncate 64-bit pointers when they're passed
to the firmware.

That and the fact that no one has said "We really need support".

-- 
Matt Fleming, Intel Open Source Technology Center
