Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaFXIyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:54:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52322 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbaFXIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:54:52 -0400
Date: Tue, 24 Jun 2014 09:54:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ricky Zhou <rickyz@google.com>
Subject: Re: [PATCH] arm: ptrace: fix syscall modification under
 PTRACE_O_TRACESECCOMP
Message-ID: <20140624085405.GA26013@arm.com>
References: <20140618202748.GA9022@www.outflux.net>
 <20140620102258.GA26626@arm.com>
 <CAGXu5jKJ07bXw_K+7uSAf=H_SDoeoaWPxS4rwuonbR71Svwwmw@mail.gmail.com>
 <20140620172330.GA30656@arm.com>
 <CAGXu5jKg0didhwZTUq8AbMnwD=RV=EaWiZWBWuar625JXGnL6w@mail.gmail.com>
 <CAGXu5j+bk3g0Dude8jfKM3dXxX8LE_46CMmcBCGdVMNX_Hu-6w@mail.gmail.com>
 <20140623084608.GA9316@arm.com>
 <CAGXu5jLJRU21YoBXjXRpfHW1-jwy_PV0hpH_oUfew23xLF4gYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLJRU21YoBXjXRpfHW1-jwy_PV0hpH_oUfew23xLF4gYg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 08:46:52PM +0100, Kees Cook wrote:
> On Mon, Jun 23, 2014 at 1:46 AM, Will Deacon <will.deacon@arm.com> wrote:
> > On Fri, Jun 20, 2014 at 07:10:46PM +0100, Kees Cook wrote:
> >> On Fri, Jun 20, 2014 at 10:36 AM, Kees Cook <keescook@chromium.org> wrote:
> >> > On Fri, Jun 20, 2014 at 10:23 AM, Will Deacon <will.deacon@arm.com> wrote:
> >> >> Right, gotcha. Thanks for the explanation. I was confused, because
> >> >> tracehook_report_syscall does the right thing (returns
> >> >> current_thread_info()->syscall), but if we don't have TIF_SYSCALL_TRACE set,
> >> >> then updates during the secure_computing callback will be ignored.
> >> >>
> >> >> However, my fix to this is significantly smaller than your patch, so I fear
> >> >> I'm still missing something.
> >> >
> >> > Oh, yes, that's much smaller. Nice! I will test this and report back.
> >>
> >> Yup, I can confirm this works. Thanks!
> >>
> >> Tested-by: Kees Cook <keescook@chromium.org>
> >
> > Thanks, Kees. I'll post a patch shortly. I'll try and remember to keep an
> > eye out for this when seccomp lands for arm64 too.
> 
> Great, thanks!
> 
> What's the state of seccomp on arm64? I saw a series back in March,
> but nothing since then? It looked complete, but I haven't set up a
> test environment yet to verify.

I think Akashi was going to repost `real soon now' so we can include them
for 3.17. He missed the merge window last time around.

Will
