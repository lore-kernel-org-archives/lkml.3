Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaG0SkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 14:40:21 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:33081 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaG0SkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 14:40:18 -0400
Date: Sun, 27 Jul 2014 20:40:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andreas Schwab <schwab@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64/crypto: fix makefile rule for aes-glue-%.o
Message-ID: <20140727184010.GA26029@ravnborg.org>
References: <CAKv+Gu96k7GOVR85EXtro3Lt0jjiJqxyvT9cwJZ1qc6uzq97bw@mail.gmail.com>
 <mvmvbqmj3b2.fsf@hawking.suse.de>
 <CAKv+Gu_9HRwAxkJjT3KRvDbupp0yzstyq1dXsXkTu9M6swdCKQ@mail.gmail.com>
 <mvmr41aj2ob.fsf@hawking.suse.de>
 <CAKv+Gu_z4VTssLDhiQxi8DRJNEUgzrM5bFzje8NXEmBiA2vqeg@mail.gmail.com>
 <CAKv+Gu-B9_sgGgw9obrBGNUFSS1JcskN34s1X4PU8F5bauHT1Q@mail.gmail.com>
 <20140724161225.GA11204@ravnborg.org>
 <CAKv+Gu8ikMGNVHeuujSf4eaK+LOFKMWxKF8i76VthnKYgvOcYQ@mail.gmail.com>
 <20140724204526.GA11754@ravnborg.org>
 <CAKv+Gu9S8vVALGFR1qL+sFfnUuYR9pkkwy0t6NuJHrs9bVxdBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9S8vVALGFR1qL+sFfnUuYR9pkkwy0t6NuJHrs9bVxdBw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Btw. the current solution is already faulty - even with the fix.
> > There are no support for make C=2 arch/.../crypto/
> >
> 
> So can you elaborate on how it is faulty?

When you run "make C=2 arch/.../crypto/" then sparse shall be run
for all .c files also if they are already built.
But due to the re-implementation of some parts of the kbuild logic
in the makefile this does not happen with the -glue file.

A minor detail - but this may not be the only wreckage we see over time.

	Sam
