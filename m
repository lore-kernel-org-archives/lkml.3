Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaGDKGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:06:21 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58024 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGDKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:06:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, viro@zeniv.linux.org.uk,
        eparis@redhat.com, rgb@redhat.com, catalin.marinas@arm.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 1/3] arm64: Add __NR_* definitions for compat syscalls
Date: Fri, 04 Jul 2014 12:06:07 +0200
Message-ID: <5418828.mxvNk2rT0e@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404458911-8214-2-git-send-email-takahiro.akashi@linaro.org>
References: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org> <1404458911-8214-2-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zPaia4I/XLjizSxS5/D1LJoMfxnsspPMkO3XVoO8ah6
 mm/z8wDgZ7glgZ9REf6ev3i8iUnCKdWt8+xMyYNCLvxVs9Cx6o
 1xrO93Euxm+zM4z9Mu97VPAInqQlF7O89v8cznhnda/08jRmtl
 FOSYfGeM3PidsDT3U6jxPl8V1QfIRDWKobIq4s+k/uM16I5uh3
 S9L1swN8QCe9FuofM8yGcyYkMXvv997M+5zNJc7Zw8XBIlJQvJ
 RQiyTSOzRRwddV80L3C12xX7A67LuUT67S72riLrBmFQVvxT5A
 tPjgWa+nDp0qHP02Ha08Iy4D5Fn9QKimVFP3KEpnIK9G6npE9u
 86WbADVN1dI5wv9JQqwA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014 16:28:29 AKASHI Takahiro wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> This patch adds __NR_* definitions to asm/unistd32.h, moves the
> __NR_compat_* definitions to asm/unistd.h and removes all the explicit
> unistd32.h includes apart from the one building the compat syscall
> table. The aim is to have the compat __NR_* definitions available but
> without colliding with the native syscall definitions.
> 
> And adds more syscall definitions for 3.16.

Can you explain in more detail why you want to add those macros? I've
looked at all three patches in the series but can't find any code using
them.

I would expect that we don't need to define those macros at all for
compat mode, since they are meant primarily for user space (glibc)
compilation, which gets them from arch/arm/include/asm/unistd.h.

	Arnd
