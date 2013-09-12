Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3ILDaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:30:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3ILDaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:30:15 -0400
Message-ID: <1378956606.5517.35.camel@marge.simpson.net>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
From: Mike Galbraith <bitbucket@online.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 05:30:06 +0200
In-Reply-To: <20130911213656.GA15367@somewhere>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	 <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
	 <1378795659.6046.41.camel@marge.simpson.net>
	 <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
	 <1378797995.6046.54.camel@marge.simpson.net>
	 <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com>
	 <0000014109b5ec0e-ca64a736-ce4a-4be2-abf6-bbf2c1c15f80-000000@email.amazonses.com>
	 <1378869632.5476.34.camel@marge.simpson.net>
	 <000001410d659f85-21128fa5-a252-4006-804c-4ff03acbd50f-000000@email.amazonses.com>
	 <20130911213656.GA15367@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:2xJ9VzVsAhTJmrf+SgbITVi72NP3SZ8SlDPEXyqvM+o
 CcFYd8BFDc+A+rwHObKcVc/w2QPrHcVuvmGwFjkZnZ/N9cP9Ek
 Jgvhjme9LR7wRe79pXJ15UkJjOowIUvrzRf84qI+PzwBXvz4Dg
 ABhc0dEk7cI0Fv2vzP0Q+onhQmL+ln0BJrhD6UexRKBhEfyBDr
 Je1b9X6F9EPjJdGXFGDKr4WA8bw7L37kS2jkoT2tFIYPxOV/A/
 ceHtlwSQlE8mR+0YQYJzA1ba80EvMyWnCsHVjBE6KQHYlnn93y
 7Ghw9FGzccLVYXiB62ubUI6EwZVgCizVHxVx25REgqk4VFZLmj
 uDQRoGHx2Z8cygxPws66iBT3aWDCayxAudyofqHkRM25PGBUvn
 393GyENFVApGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 23:36 +0200, Frederic Weisbecker wrote: 
> On Wed, Sep 11, 2013 at 02:21:06PM +0000, Christoph Lameter wrote:
> > On Wed, 11 Sep 2013, Mike Galbraith wrote:
> > 
> > > Mind saying why?  To me, creating properties of exclusive sets of CPUs
> > > that the interface which manages sets and their properties is not fully
> > > aware of is a dainbramaged thing to do.
> > 
> > cpusets is being replaced by cgropus.
> 
> You are confusing me. Cpusets is a cgroups subsystem, how can it be replaced
> by it?

Yeah, the only irritant I know of is the cpuset API variability.  It has
a backward compatibility mount option, so anything other than the user
mounting makes the API selection decision for him/her.  systemd mounts
cpuset, i.e. OS component pokes OS API backward compatibility button,
breaking OS API backward compatibility for the user, who then has to
squabble with OS component over button possession if he wants his old
cpuset API using toys to continue to work.

-Mike

