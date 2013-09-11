Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3IKOxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:53:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3IKOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:53:33 -0400
Message-ID: <1378911206.5476.134.camel@marge.simpson.net>
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
Date: Wed, 11 Sep 2013 16:53:26 +0200
In-Reply-To: <000001410d659f85-21128fa5-a252-4006-804c-4ff03acbd50f-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	 <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
	 <1378795659.6046.41.camel@marge.simpson.net>
	 <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
	 <1378797995.6046.54.camel@marge.simpson.net>
	 <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com>
	 <0000014109b5ec0e-ca64a736-ce4a-4be2-abf6-bbf2c1c15f80-000000@email.amazonses.com>
	 <1378869632.5476.34.camel@marge.simpson.net>
	 <000001410d659f85-21128fa5-a252-4006-804c-4ff03acbd50f-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:sTfoahV93hGyuHT0fherFZ77WOVB7KQWln7LX+umQtE
 7Vc40yxwtRRuFSn3d3QPXWspkQRwhfCVJVTbKZVmVl0vS/4eJ8
 Qh5qLlt4jlzDi29+ZjK8Aw6TmcX49UozuhJ/7P2C7Vjjrb3jqy
 e5QxE/7nj+riwnOG2bGJOHJExcwmkn+ylmfrGX90I89iXRIgm3
 t8TtRhWZipH9cp6K+ErG8ApwAjJV9BHZdyNoN6avTXT3Bmorpi
 PR4+67gGGDUojV44dW4DYvDuNgmVPcSi0v52UurGISs1lCQC+t
 67lpxPouoIMJt4cuisFr5XTOO9Ar3ldJTRHtadLO4+8sOcZfLd
 r7Lq4jzRAKplLcJfSBpFc8TxBPR6u8bvRdqGbID1CyEg9qG5j2
 XHmCZNLL4wagA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 14:21 +0000, Christoph Lameter wrote: 
> On Wed, 11 Sep 2013, Mike Galbraith wrote:
> 
> > Mind saying why?  To me, creating properties of exclusive sets of CPUs
> > that the interface which manages sets and their properties is not fully
> > aware of is a dainbramaged thing to do.
> 
> cpusets is being replaced by cgropus. And the mechanism adds some
> significant latencies to core memory management processing path.

You don't have to use or even configure in all controllers.

> Also many folks in finance like to deal directly with the hardware
> (processor numbers, affinity masks etc). There are already numerous ways
> to specify these masks. Pretty well established. Digging down a cpuset
> hierachy is a bit tedious. Then these cpusets can also overlap which
> makes the whole setup difficult.

These kind of things have to be exclusive set attributes 'course,
overlapping nohz_tick/full/off just ain't gonna work very well.

I hacked it up for my rt kernel to turn the tick on/off, and disable rt
load balancing (cpupri adds jitter) on a per exclusive set basis.  The
cpuset bit is easy.  Connecting buttons to scheduler and whatnot can
make cute little "You'd better not EVER submit this" warts though :)

> If cpusets can be used on top then ok but I would like it not to be
> required to have that compiled in.

IMHO, it makes much more sense to unify set attributes in cpusets,
fixing up or griping about whatever annoys HPC boxen/folks.

But whatever, I only piped in to mention that isolcpus wants to die, and
I've done that, so I can pipe-down now.

-Mike


