Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaIBJbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:31:33 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39686 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751525AbaIBJbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:31:31 -0400
Date: Tue, 2 Sep 2014 10:31:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "arndb@arndb.de" <arndb@arndb.de>, Deepak Saxena <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 2/6] arm64: ptrace: allow tracer to skip a system
	call
Message-ID: <20140902093121.GL30401@n2100.arm.linux.org.uk>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org> <1408611405-8943-3-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com> <53F69045.7010301@linaro.org> <20140826175128.GD23445@arm.com> <53FD72E2.4020103@linaro.org> <20140901114751.GG30401@n2100.arm.linux.org.uk> <54058421.5070506@linaro.org> <20140902091622.GK30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902091622.GK30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 10:16:22AM +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 02, 2014 at 05:47:29PM +0900, AKASHI Takahiro wrote:
> > On 09/01/2014 08:47 PM, Russell King - ARM Linux wrote:
> >> On Wed, Aug 27, 2014 at 02:55:46PM +0900, AKASHI Takahiro wrote:
> >>> 1)
> >>> setting x0 to -ENOSYS is necessary because, otherwise, user-issued syscall(-1) will
> >>> return a bogus value when audit tracing is on.
> >>>
> >>> Please note that, on arm,
> >>>                   not traced      traced
> >>>                   ------          ------
> >>> syscall(-1)      aborted         OOPs(BUG_ON)
> >>> syscall(-3000)   aborted         aborted
> >>> syscall(1000)    ENOSYS          ENOSYS
> >>
> >> Two points here:
> >>
> >> 1. You've found a case which causes a BUG_ON().  Where is the bug report
> >>     for this, so the problem can be investigated and resolved?
> >
> > I think that I mentioned it could also happen on arm somewhere in a talk
> > with Will, but don't remember exactly when.
> 
> Sorry, not good enough.  Please report this bug so it can be investigated
> and fixed.

I'm going to go further than this, and tell you that you have been
downright irresponsible here, and I'm disgusted by your behaviour over
this.

You have revealed a potential security problem publically, effectively
giving details about how to cause it, but without having first reported
it to people who can fix it, nor providing a fix for it.

Why is it a security problem?  Although it can't be used to gain
information, it can be used potentially to deny service.  Any user can
trace a task which they own, and then set the task's syscall to -1,
which according to you results in a kernel oops.

If the kernel oops happens while holding any locks, that part of the
system becomes non-functional and can result in all userland stopping
dead.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
