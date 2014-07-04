Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbaGDLR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:17:58 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61075 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaGDLR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:17:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: linaro-kernel@lists.linaro.org, viro@zeniv.linux.org.uk, eparis@redhat.com,
        rgb@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 1/3] arm64: Add __NR_* definitions for compat syscalls
Date: Fri, 04 Jul 2014 13:17:43 +0200
Message-ID: <4723610.G5HFZHp0Yu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53B68A8B.1020106@linaro.org>
References: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org> <5418828.mxvNk2rT0e@wuerfel> <53B68A8B.1020106@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1QKOdmLVsASiYTv1KofcP5+MTD15qx4WLTbq+PfDanC
 ZkOBrHGLOK1Ls+knE7p0cjS7DZuNK9PV3+cuwvA1BMPi/BN4ba
 SFkwkOnp9yAlzPFfkmqiA09MgrvzHjOdG2SjAfCdWA/Id224ik
 nmxEr+ENhqWU3Jnb5Q/ZuefbhuC9scT4k3JmRzFuTuvWmJl83Q
 QGOjrMqRvoQrjiBYs9ElS4XsDE9Gpc5G/gnmH+RkOhMSZsiIg1
 cu6oJ0aRH1uCUyURPHEqq/sZ8JHktqLMe3DA7X2k0kV8l4xEbq
 s4F3LBAZRv/ImfSoSEcqjC04J312uJC0yofUTWhChtP0ChhVSC
 lp65Kv0TvWo2+phzBJT8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014 20:05:47 AKASHI Takahiro wrote:
> On 07/04/2014 07:06 PM, Arnd Bergmann wrote:
> > On Friday 04 July 2014 16:28:29 AKASHI Takahiro wrote:
> >> From: Catalin Marinas <catalin.marinas@arm.com>
> >>
> >> This patch adds __NR_* definitions to asm/unistd32.h, moves the
> >> __NR_compat_* definitions to asm/unistd.h and removes all the explicit
> >> unistd32.h includes apart from the one building the compat syscall
> >> table. The aim is to have the compat __NR_* definitions available but
> >> without colliding with the native syscall definitions.
> >>
> >> And adds more syscall definitions for 3.16.
> >
> > Can you explain in more detail why you want to add those macros? I've
> > looked at all three patches in the series but can't find any code using
> > them.
> 
> Right. "unistd32.h" is not used by this patch, but by lib/compat_audit.c.
> when I thought of adding audit support for arm64, there was duplicated code
> of auditing compat system calls across many architectures.
> lib/compat_audit.c fixes this issue but at the same time it also requires
> __NR_* macros for a couple of compat system calls which arm64 didn't have.
> 
> In the first implementation, I generated an extra generated/asm/unistd_32.h
> from the original asm/unist32.h by using a sed script. But Catalin suggested
> (agreed?) to modify unistd32.h for this purpose.
> 
> See
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/228992.html
> 

Ok, thanks for the explanation. It would be good to have that in the changeset
comment as well, in case other people wonder about the same question.

	Arnd
