Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3IJVK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:10:26 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:63049 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab3IJVKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:10:21 -0400
Date: Tue, 10 Sep 2013 21:10:20 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: Mike Galbraith <bitbucket@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com>
Message-ID: <0000014109b5ec0e-ca64a736-ce4a-4be2-abf6-bbf2c1c15f80-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com> <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com> <1378795659.6046.41.camel@marge.simpson.net> <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
 <1378797995.6046.54.camel@marge.simpson.net> <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Gilad Ben-Yossef wrote:

> On Tue, Sep 10, 2013 at 10:26 AM, Mike Galbraith <bitbucket@online.de> wrote:
>
> >
> > Hammering on the wrong spot makes removing isolcpus take longer, and
> > adds up to more hammering in the long run, no?  Hearing you mention
> > isolcpus, I just thought I should mention that it wants to go away, so
> > might not be the optimal spot for isolation related tinkering.
>
>
> OK, so I'll bite - isolcpu currently has special magic to do its thing but AFAIK
> part of the reason isolcpu works "better" (for some definition of
> better, for some
> work loads) is simply because it blocks migration earlier than you get with
> cpusets.
>
> What if we  re-did the implementation of isolcpu as creating an
> cpuset with migration off as early as possible in the boot process, prior to
> spawning init?
>
> So basically, isolcpus becomes just a way to configure a cpuset early?

I surely wish we had the ability to use tickless without the need for
things like cpusets etc.

isolcpus is broken as far as I can tell. Lets lay it to rest and come up
with a sane way to configure these things. Autoconfig if possible.



