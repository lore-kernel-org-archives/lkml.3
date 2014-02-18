Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaBRTjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:39:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbaBRTjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:39:39 -0500
Message-ID: <1392752362.2165.31.camel@flatline.rdu.redhat.com>
Subject: Re: [ARCH question] Do syscall_get_nr and syscall_get_arguments
 always work?
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jonas Bonn <jonas.bonn@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-arch <linux-arch@vger.kernel.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>
Date: Tue, 18 Feb 2014 14:39:22 -0500
In-Reply-To: <CALCETrXXnSdyc5VpT8f6uu6kbO1cq4QwdKqr9z8AOhY_wsoBLA@mail.gmail.com>
References: <CALCETrU6M=Abo1z2cRoZy07-=3bwKiK84gCSMcBPLA1TkXPb8A@mail.gmail.com>
	 <CACM3HyHwrKQAWZRhE2N1VtGKu1xSvcGeuMG1Ag+vzP2BA111cQ@mail.gmail.com>
	 <CALCETrXXnSdyc5VpT8f6uu6kbO1cq4QwdKqr9z8AOhY_wsoBLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 08:40 -0800, Andy Lutomirski wrote:
> On Fri, Feb 7, 2014 at 4:58 AM, Jonas Bonn <jonas.bonn@gmail.com> wrote:
> > Hi Andy,
> >
> > On 5 February 2014 00:50, Andy Lutomirski <luto@amacapital.net> wrote:
> >>
> >> I can't even find the system call entry point on mips.
> >>
> >>
> >> Is there a semi-official answer here?
> >
> > I don't have an official answer for you, but when I wanted to do
> > something with these entry points a couple of years back I discovered
> > that they aren't very thoroughly implemented across the various
> > architectures.  I started cleaning this up and can probably dig up
> > some of this for you if you need it.
> 
> The syscall_get_xyz functions are certainly implemented and functional
> in all relevant architectures -- the audit code is already using them.
>  The thing I'm uncertain about is whether they are usable with no
> syscall slow path bits set.
> 
> I guess that, if the syscall restart logic needs to read the argument
> registers, then they're probably reliably saved...

Al just indicated to me that on at least ia64, syscall_get_arguments()
is really expensive.  So maybe not a deal breaker, but sounds like we'd
lose a lot of performance trying to get them at syscall exit...

