Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKGJcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:32:01 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:50501 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaKGJbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:31:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, roland@hack.frob.com,
        oleg@redhat.com, linaro-kernel@lists.linaro.org,
        linux@arm.linux.org.uk, keescook@chromium.org, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, dsaxena@linaro.org
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Date: Fri, 07 Nov 2014 10:30:53 +0100
Message-ID: <1977974.l97vvy7Y8b@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LMA30pxAgBSGgAQrjJaeCwN3XXiLXDiu805SUpIleo7
 KY+N7FZd0/do/m9BP96zzRGBRhTB52ijnAbC4+mdOBMKZrK/EN
 gAie+pEsiy5JZq+ATVnCTA+AgPFLYWj0/ysq3fJROBl1ZL3uCD
 gj6r0ofPxyeinxrKdS67LH5QDxC7t9JiMW1/qaAGj5D4xQlE3Q
 f6oXS/Bj1qcu41rtw6K7LgQvC6XPj71g/MDP8rzPar27Z8QnIz
 XMN7StXQ/Yer1w+ku7o6zKApXDyJMmihdA/ufuIxj3OBr1m1Cd
 Y/ikNmG9VTU/Wwhz0t9Lk3cVFlP36Y9hrDkgx0tUf5c38zEeI8
 E+2MhT0GiEwGl5TvQPaQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 16:47:23 AKASHI Takahiro wrote:
> This patch adds a new generic ptrace request, PTRACE_SET_SYSCALL.
> It can be used to change a system call number as follows:
>     ret = ptrace(pid, PTRACE_SET_SYSCALL, null, new_syscall_no);
> 'new_syscall_no' can be -1 to skip this system call, you need to modify
> a register's value, in arch-specific way, as return value though.
> 
> Please note that we can't define PTRACE_SET_SYSCALL macro in
> uapi/linux/ptrace.h partly because its value on arm, 23, is used as another
> request on sparc.
> 
> This patch also contains an example of change on arch side, arm.
> Only syscall_set_nr() is required to be defined in asm/syscall.h.
> 
> Currently only arm has this request, while arm64 would also have it
> once my patch series of seccomp for arm64 is merged. It will also be
> usable for most of other arches.
> See the discussions in lak-ml:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/300167.html
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> 

Can you describe why you are moving the implementation? Is this a feature
that we want to have on all architectures in the future? As you say,
only arm32 implements is at the moment.

	Arnd
