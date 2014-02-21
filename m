Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaBUVWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:22:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbaBUVWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:22:04 -0500
Date: Fri, 21 Feb 2014 16:21:44 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jonas Bonn <jonas.bonn@gmail.com>, linux-arch <linux-arch@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com
Subject: Re: [ARCH question] Do syscall_get_nr and syscall_get_arguments
 always work?
Message-ID: <20140221212144.GF17952@madcap2.tricolour.ca>
References: <CALCETrU6M=Abo1z2cRoZy07-=3bwKiK84gCSMcBPLA1TkXPb8A@mail.gmail.com>
 <CACM3HyHwrKQAWZRhE2N1VtGKu1xSvcGeuMG1Ag+vzP2BA111cQ@mail.gmail.com>
 <CALCETrXXnSdyc5VpT8f6uu6kbO1cq4QwdKqr9z8AOhY_wsoBLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXXnSdyc5VpT8f6uu6kbO1cq4QwdKqr9z8AOhY_wsoBLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/07, Andy Lutomirski wrote:
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

I just stumbled on syscall_get_arch missing on at least s390x.  Others
may have it missing too, but the build quit on discovering that one.

> I guess that, if the syscall restart logic needs to read the argument
> registers, then they're probably reliably saved...
> 
> --Andy

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
