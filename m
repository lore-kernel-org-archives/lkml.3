Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3LMLjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:39:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55085 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3LMLjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:39:52 -0500
Date: Fri, 13 Dec 2013 11:39:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulli.kroll@googlemail.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
Message-ID: <20131213113903.GE4360@n2100.arm.linux.org.uk>
References: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com> <20131213095655.GB4360@n2100.arm.linux.org.uk> <CACmBeS1d-EX5oPD8f7P-ufmF=MutdTO+LgG23Cb0=biR8yQPCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACmBeS1d-EX5oPD8f7P-ufmF=MutdTO+LgG23Cb0=biR8yQPCg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:51:09AM +0100, Jonas Jensen wrote:
> On 13 December 2013 10:56, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > So, having these symbols enabled (provided the right ones for FA526 are
> > also enabled) makes no difference.  So I don't buy your explanation.
> 
> The explanation is indeed false, CPU_FA526 and CPU_ARM920T get along just fine.
> That's not where the problem is.
> 
> Panic goes away after removing CONFIG_ARM_THUMB=y.
> 
> I assume this is what should happen on processors without thumb?

I see what's causing this: the kuser helpers are using "bx lr" to return
which will be undefined on non-Thumb CPUs.  We generally cope fine with
non-Thumb CPUs, conditionalising where necessary on HWCAP_THUMB or the
T bit in the PSR being set.

However, it looks like the kuser helpers got missed.  As a check, please
look at arch/arm/kernel/entry-armv.S, find the line with:

	.macro	usr_ret, reg

and ensure that the mov pc, \reg case always gets used.  Please report
back.

Thanks.
