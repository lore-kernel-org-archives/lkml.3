Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3IKDUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:20:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3IKDUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:20:52 -0400
Message-ID: <1378869632.5476.34.camel@marge.simpson.net>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
From: Mike Galbraith <bitbucket@online.de>
To: Christoph Lameter <cl@linux.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 05:20:32 +0200
In-Reply-To: <0000014109b5ec0e-ca64a736-ce4a-4be2-abf6-bbf2c1c15f80-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	 <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
	 <1378795659.6046.41.camel@marge.simpson.net>
	 <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
	 <1378797995.6046.54.camel@marge.simpson.net>
	 <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com>
	 <0000014109b5ec0e-ca64a736-ce4a-4be2-abf6-bbf2c1c15f80-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:LnnnsAP4KumZKbUaqmOWOG2nRoPvywIGetonm2tdpLl
 0pNxd77Es9eDQqMAuTvXXsfYkV0zrLWSliDqm+YSv2IQ7xiT1k
 fV/XljKuHNxjHvwQzFdnKTKXEg6gomojVlK8lF3Pqo8rihcmvM
 DSAz/eJh2SE1ikqiRdkXcvOXnYJjyay2V0VIPeZ1UgGN7gpGL7
 maIBZOJVW+a1eGuU0MSe3u8qBO99UElGC2cv0mklDsi1jSgN4C
 Ii43AM0JB5d0HmIxXdEHYOtanWYprU5Jkrd0LR2uKorkXO53WP
 PiWRoPuOqmD+GxVEmVheCUggW36US8a11E7+nKg71U5eUDglc5
 xEGskMAKNeei7hDUau2y+EBAaniJNT/ccWZ2AZRCv5Nymax+yL
 zGG2kWxUlyOow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 21:10 +0000, Christoph Lameter wrote: 
> On Tue, 10 Sep 2013, Gilad Ben-Yossef wrote:
> 
> > On Tue, Sep 10, 2013 at 10:26 AM, Mike Galbraith <bitbucket@online.de> wrote:
> >
> > >
> > > Hammering on the wrong spot makes removing isolcpus take longer, and
> > > adds up to more hammering in the long run, no?  Hearing you mention
> > > isolcpus, I just thought I should mention that it wants to go away, so
> > > might not be the optimal spot for isolation related tinkering.
> >
> >
> > OK, so I'll bite - isolcpu currently has special magic to do its thing but AFAIK
> > part of the reason isolcpu works "better" (for some definition of
> > better, for some
> > work loads) is simply because it blocks migration earlier than you get with
> > cpusets.
> >
> > What if we  re-did the implementation of isolcpu as creating an
> > cpuset with migration off as early as possible in the boot process, prior to
> > spawning init?
> >
> > So basically, isolcpus becomes just a way to configure a cpuset early?
> 
> I surely wish we had the ability to use tickless without the need for
> things like cpusets etc.

Mind saying why?  To me, creating properties of exclusive sets of CPUs
that the interface which manages sets and their properties is not fully
aware of is a dainbramaged thing to do.  

-Mike

