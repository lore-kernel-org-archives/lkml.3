Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbbA2CMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:12:35 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:53658 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537AbbA2CMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:12:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Timur Tabi <timur@codeaurora.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>, rgb@redhat.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, eparis@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, linux-audit@redhat.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 1/3] arm64: Add __NR_* definitions for compat syscalls
Date: Wed, 28 Jan 2015 22:35:01 +0100
Message-ID: <12610204.3KbMJUth1j@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAOZdJXUhpmi0SM5izDYQnx8SHjWjqOFVduV0+boPw6+YCKP5+g@mail.gmail.com>
References: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org> <1404458911-8214-2-git-send-email-takahiro.akashi@linaro.org> <CAOZdJXUhpmi0SM5izDYQnx8SHjWjqOFVduV0+boPw6+YCKP5+g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:3YIGh/+CVKefHS/feNyHiQ0MvnBLg0hnqB+7H6AFiJFtfgXZibE
 DID089RvCPhJ3183jyFnqXwbbop7uKlXycuBNb8qaj+ytqgcyWFo2ju2XVrtYW+BFv22RmU
 X0OZdTmOhvZtcdDF3EwDRviZzA4HppZS/Bm+LDZFi0+Pkl/oilka8GOylGeHEoNUwttkNuM
 VH8cWh+xCGJbUFdDrDVGg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 15:31:49 Timur Tabi wrote:
> On Fri, Jul 4, 2014 at 2:28 AM, AKASHI Takahiro
> <takahiro.akashi@linaro.org> wrote:
> > +#define __ARM_NR_COMPAT_BASE           0x0f0000
> > +#define __ARM_NR_compat_cacheflush     (__ARM_NR_COMPAT_BASE+2)
> > +#define __ARM_NR_compat_set_tls                (__ARM_NR_COMPAT_BASE+5)
> 
> I know this patch is six months old, but I was wondering if anyone
> knows of any plans to make these syscalls available to 64-bit apps?
> We have a 32-bit app that uses __ARM_NR_compat_cacheflush, and we'd
> like to port that app to 64-bit.  I'm just not sure how to start doing
> that, since there don't appear to be any 64-bit ARM-specific syscalls.
> 

You can add architecture specific syscalls by using the 16 numbers following
__NR_arch_specific_syscall. Whether it makes sense to have a cacheflush
syscall on arm64, I have no idea.

I believe that we should not need a set_tls syscall though.

	Arnd
