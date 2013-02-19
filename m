Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3BSIuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:50:39 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55005 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3BSIui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:50:38 -0500
Date: Tue, 19 Feb 2013 00:50:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130219085019.GC3093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130215011503.GA11914@redhat.com>
 <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
 <20130215174435.GA2792@linux.vnet.ibm.com>
 <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
 <CA+55aFwHtFeN97E-zW2QKQWH8vu=g29cxevvEnpEnHc8dx7oWA@mail.gmail.com>
 <CA+55aFyXo89LQ0mboxVYB5SJ08D8=Kv0=cqYHAd6-H7nmp=S-w@mail.gmail.com>
 <20130216192554.GB7035@linux.vnet.ibm.com>
 <CA+55aFy821kt0cz=nNB45e0K-hGUfairbTEgNP6E65jkA6bWaA@mail.gmail.com>
 <51215E6C.5090102@zytor.com>
 <20130218084130.GB15989@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130218084130.GB15989@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021908-3620-0000-0000-00000142E356
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 09:41:30AM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 02/16/2013 11:46 AM, Linus Torvalds wrote:
> > >Adding Peter Anvin to the people, just in case he sees what's wrong
> > >with the system call stub generation that keeps excessively old object
> > >files around. If it's easy to fix, it might be worth trying to make it
> > >ok to switch from i386 to x86-64 and back in the same tree.
> > 
> > I have not been able to reproduce this; it seems to Just 
> > Work[TM].
> > 
> > The syscall header stuff is definitely not to blame: it 
> > doesn't even *see* the CONFIG_ settings; instead they are only 
> > used to determine which subset of files to create, but the 
> > files themselves are configuration-independent.  This is by 
> > design.
> > 
> > As such, without an actual known to fail test case there isn't 
> > much I can do.
> 
> I tried (based on the versions given by Paul):
> 
>   git checkout v3.7-rc7
>   make ARCH=i386 defconfig
>   make -j64 bzImage
> 
>   git checkout v3.8-rc7
>   make ARCH=x86_64 olddefconfig
>   make -j64 bzImage
> 
> but it built just fine. The build bug might depend on the 
> specific config file, or might depend on tooling details?

The problem is that the git tree I used is one that I build out of
very infrequently, and so all I really know about the previous
build was that it was done a long time ago.  :-(

							Thanx, Paul

