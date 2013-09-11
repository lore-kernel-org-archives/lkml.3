Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3IKObV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:31:21 -0400
Received: from a14-29.smtp-out.amazonses.com ([54.240.14.29]:34659 "EHLO
	a14-29.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753615Ab3IKObU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:31:20 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2013 10:31:20 EDT
Date: Wed, 11 Sep 2013 14:21:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mike Galbraith <bitbucket@online.de>
cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <1378869632.5476.34.camel@marge.simpson.net>
Message-ID: <000001410d659f85-21128fa5-a252-4006-804c-4ff03acbd50f-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com> <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com> <1378795659.6046.41.camel@marge.simpson.net> <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
 <1378797995.6046.54.camel@marge.simpson.net> <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com> <0000014109b5ec0e-ca64a736-ce4a-4be2-abf6-bbf2c1c15f80-000000@email.amazonses.com> <1378869632.5476.34.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.11-54.240.14.29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Mike Galbraith wrote:

> Mind saying why?  To me, creating properties of exclusive sets of CPUs
> that the interface which manages sets and their properties is not fully
> aware of is a dainbramaged thing to do.

cpusets is being replaced by cgropus. And the mechanism adds some
significant latencies to core memory management processing path.

Also many folks in finance like to deal directly with the hardware
(processor numbers, affinity masks etc). There are already numerous ways
to specify these masks. Pretty well established. Digging down a cpuset
hierachy is a bit tedious. Then these cpusets can also overlap which
makes the whole setup difficult.

If cpusets can be used on top then ok but I would like it not to be
required to have that compiled in.

