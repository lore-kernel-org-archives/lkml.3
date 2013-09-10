Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3IJH4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:56:45 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:55694 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3IJH4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:56:44 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1378797995.6046.54.camel@marge.simpson.net>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	<CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
	<1378795659.6046.41.camel@marge.simpson.net>
	<CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
	<1378797995.6046.54.camel@marge.simpson.net>
Date: Tue, 10 Sep 2013 10:56:43 +0300
Message-ID: <CAOtvUMdRmDYP_e7eFX1akU8vZ=dcVOnFDrBjKufumOaBxxXF3A@mail.gmail.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of cpus.
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:26 AM, Mike Galbraith <bitbucket@online.de> wrote:

>
> Hammering on the wrong spot makes removing isolcpus take longer, and
> adds up to more hammering in the long run, no?  Hearing you mention
> isolcpus, I just thought I should mention that it wants to go away, so
> might not be the optimal spot for isolation related tinkering.


OK, so I'll bite - isolcpu currently has special magic to do its thing but AFAIK
part of the reason isolcpu works "better" (for some definition of
better, for some
work loads) is simply because it blocks migration earlier than you get with
cpusets.

What if we  re-did the implementation of isolcpu as creating an
cpuset with migration off as early as possible in the boot process, prior to
spawning init?

So basically, isolcpus becomes just a way to configure a cpuset early?


Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
