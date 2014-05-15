Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaEOL6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:58:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaEOL6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:58:06 -0400
Date: Thu, 15 May 2014 13:57:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140515115751.GK30445@twins.programming.kicks-ass.net>
References: <20140513094737.GU30445@twins.programming.kicks-ass.net>
 <53721FD4.6060300@redhat.com>
 <20140513142328.GE2485@laptop.programming.kicks-ass.net>
 <53731D12.7040804@linux.vnet.ibm.com>
 <20140514094426.GF30445@twins.programming.kicks-ass.net>
 <5374387E.4080802@linux.vnet.ibm.com>
 <20140515083531.GE30445@twins.programming.kicks-ass.net>
 <53747EE4.3020605@linux.vnet.ibm.com>
 <20140515090638.GI30445@twins.programming.kicks-ass.net>
 <53748A5D.6070605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mMJklh8hhp8IL6EK"
Content-Disposition: inline
In-Reply-To: <53748A5D.6070605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mMJklh8hhp8IL6EK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 05:35:25PM +0800, Michael wang wrote:
> On 05/15/2014 05:06 PM, Peter Zijlstra wrote:
> [snip]
> >> However, when the group level is too deep, that doesn't works any more=
=2E..
> >>
> >> I'm not sure but seems like 'deep group level' and 'vruntime bonus for
> >> sleeper' is the keep points here, will try to list the root cause after
> >> more investigation, thanks for the hints and suggestions, really helpf=
ul ;-)
> >=20
> > How deep is deep? You run into numerical problems quite quickly, esp.
> > when you've got lots of CPUs. We've only got 64bit to play with, that
> > said there were some patches...
>=20
> It's like:
>=20
> 	/cgroup/cpu/l1/l2/l3/l4/l5/l6/A
>=20
> about level 7, the issue can not be solved any more.

That's pretty retarded and yeah, that's way past the point where things
make sense. You might be lucky and have l1-5 as empty/pointless
hierarchy so the effective depth is less and then things will work, but
*shees*..

> > -#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power us=
age under light load  */
> > +#if 1 /* BITS_PER_LONG > 32 -- currently broken: it increases power us=
age under light load  */
>=20
> That is trying to solve the load overflow issue, correct?
>=20
> I'm not sure which account will turns to be huge when group get deeper,
> the load accumulation will suffer discount when passing up, isn't it?
>=20

It'll use 20 bits for precision instead of 10, so it gives a little more
'room' for deeper hierarchies/big cpu-count.

All assuming you're running 64bit kernels of course.

--mMJklh8hhp8IL6EK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdKu5AAoJEHZH4aRLwOS632oP/jONl08mE6k9NOf0D9FhhDGk
UvkzwLm0Dg6QYc14k4kvLHcDtA72TfoYhd9C3h79LDGfQTCKRv5zQM8qEGLm+nmB
kaUTSLxFBTzUdLwTgJFtmgSOqHEQjT01f1FfUBQU9XfN0EM5heiOs55fAqNPdH24
by6R/Vca2P9Uu6Gr+kRRLcmMGgPCWGmvfvEcgRTbhq/mNULE5/pFvscxSns9yy44
ooesIsPhg2PqNzjCLWa/YnVBkI6viOqDemeYGV0ZX3ugkZIIxNn4rUF6Xvx68FmF
Xl8okQ0mpdzOE8VkVgZlXkNOaS+jxxjFUJ5n8fCTtmYI9e7ZDLczQpQHuTqDpV87
WfJybUqH0E0QV1dhjfQWs20uoGmx3VehvZOdVYq9JC//N6cGbo7xw+UIrHD8ALAM
8hfPtGN4OOa+f0YrYQ+Glf8et30X+AKY+eXEri16JY5RSsI3ADwWqDELWzui5hDv
t1QSvJv9Otg2l6v40rpD2Q5LNuF6MYMxWfXyvnoN7mKxlJDQ/YH1Q0Zb2Xl2Dp0e
6PIFwg0MueaTfbtUreh/SbxD52j0O/C/CcmKZqCLVy2c48d2FCmjN3XdwnGVuish
ynNhYCUbT9elkbGJ+a7VeB1+5CaAN1AmpdRtvSATd+DpYbV6CLrOEw4KnHcnbBeT
gLnkUSGg+QcagD0Pk7L+
=jstL
-----END PGP SIGNATURE-----

--mMJklh8hhp8IL6EK--
