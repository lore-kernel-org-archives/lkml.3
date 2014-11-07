Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaKGMEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:04:07 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:63707 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaKGMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:04:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Date: Fri, 07 Nov 2014 13:03 +0100
Message-ID: <1678531.AUssrM9PAs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141107115551.GC18916@arm.com>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <1977974.l97vvy7Y8b@wuerfel> <20141107115551.GC18916@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zynY6MFqzbZKD2nPUnbnGAGWJdZMsohhisgfMUoxZZs
 MkToQ3DNqPmFyv2yHneor9rC8UhNszrzwf06+zV0P1CNwTEvlf
 zj7+opC+gJjZOf5jy3OGc0qT69WRwptYoFLn2AkxKKIBx57yko
 H6a00yCNRrLTvHGaMjfQfWjWXp2+C+KKbjf7AOZxVOwWWKMEtw
 biRTPjJQ01xr8A3nFBVGr6SZ75h332lEBu4ogBMLS2SlHwBQLc
 xjGKqzRl6T8NMQs3Bdz+MaDav7DuvDjJaKeStXxHmKbcdQCCto
 YA4WuvxlZ4Kes97UZQzqFe1soMaK7cMymJgTfUUtAGRwrNIRGc
 zNwN/VdrJ/XNTvkfJZI0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 11:55:51 Will Deacon wrote:
> On Fri, Nov 07, 2014 at 09:30:53AM +0000, Arnd Bergmann wrote:
> > On Friday 07 November 2014 16:47:23 AKASHI Takahiro wrote:
> > > This patch adds a new generic ptrace request, PTRACE_SET_SYSCALL.
> > > It can be used to change a system call number as follows:
> > >     ret = ptrace(pid, PTRACE_SET_SYSCALL, null, new_syscall_no);
> > > 'new_syscall_no' can be -1 to skip this system call, you need to modify
> > > a register's value, in arch-specific way, as return value though.
> > > 
> > > Please note that we can't define PTRACE_SET_SYSCALL macro in
> > > uapi/linux/ptrace.h partly because its value on arm, 23, is used as another
> > > request on sparc.
> > > 
> > > This patch also contains an example of change on arch side, arm.
> > > Only syscall_set_nr() is required to be defined in asm/syscall.h.
> > > 
> > > Currently only arm has this request, while arm64 would also have it
> > > once my patch series of seccomp for arm64 is merged. It will also be
> > > usable for most of other arches.
> > > See the discussions in lak-ml:
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/300167.html
> > > 
> > > Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> > > 
> > 
> > Can you describe why you are moving the implementation? Is this a feature
> > that we want to have on all architectures in the future? As you say,
> > only arm32 implements is at the moment.
> 
> We need this for arm64 and, since all architectures seem to have a mechanism
> for setting a system call via ptrace, moving it to generic code should make
> sense for new architectures too, no?

It makes a little more sense now, but I still don't understand why you
need to set the system call number via ptrace. What is this used for,
and why doesn't any other architecture have this?

	Arnd
