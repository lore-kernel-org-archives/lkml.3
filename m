Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab3I0Fll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:41:41 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751050Ab3I0Flj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:41:39 -0400
Message-ID: <52451A8D.4080509@nod.at>
Date: Fri, 27 Sep 2013 07:41:33 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Michal Marek <mmarek@suse.cz>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/2] arch/um: make it work with defconfig and x86_64
References: <1380255287-5818-1-git-send-email-artagnon@gmail.com> <1380255287-5818-2-git-send-email-artagnon@gmail.com>
In-Reply-To: <1380255287-5818-2-git-send-email-artagnon@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2013 06:14, schrieb Ramkumar Ramachandra:
> arch/um/defconfig only lists one default configuration, and that applies
> only to the i386 architecture.  Replace it with two minimal
> configuration files generated using `make savedefconfig`:
> 
>   i386_defconfig and x86_64_defconfig
> 
> The build scripts now require two updates:
> 
> 1. um's Kconfig (arch/x86/um/Kconfig) should specify an ARCH_DEFCONFIG
>    section explicitly pointing to these scripts if the required
>    variables are set.  Take care to remove the DEFCONFIG_LIST section
>    defined in the included file arch/um/Kconfig.common.
> 
> 2. um's Makefile (arch/um/Makefile) should set KBUILD_DEFCONFIG properly
>    for the top-level Makefile to pick up.  Copy the logic in
>    arch/x86/Makefile to properly pick the defconfig file depending on
>    the actual architecture; except we're working with $SUBARCH here,
>    instead of $ARCH.
> 
> Now, you can do:
> 
>   $ ARCH=um make defconfig
>   $ ARCH=um make
> 
> and successfully build User-Mode Linux on an x86_64 box in default
> configuration.

I don't much like the commit message, but I will amend it myself.
I.e. defconfig worked always on x86_64, you have to specify SUBARCH=x86_64.
Your patch adds the handy feature that make defconfig will use the host arch
automatically.

Patch queued for 3.13-rc1.

Thanks,
//richard
