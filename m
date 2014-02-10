Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaBJRCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:02:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53119 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaBJRCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:02:06 -0500
Date: Mon, 10 Feb 2014 18:01:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Norton, Scott J" <scott.norton@hp.com>
Cc: "Long, Wai Man" <waiman.long@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Bueso, Davidlohr" <davidlohr@hp.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
Message-ID: <20140210170144.GO9987@twins.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
 <1390949495.2807.52.camel@j-VirtualBox>
 <20140129115142.GE9636@twins.programming.kicks-ass.net>
 <52F2B0C2.8040408@hp.com>
 <20140206140435.GU8874@twins.programming.kicks-ass.net>
 <52F3D84D.5060309@hp.com>
 <E2BC6EB51A09EC46A4906DEA4A9496EE0B7077AA@G9W0719.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2BC6EB51A09EC46A4906DEA4A9496EE0B7077AA@G9W0719.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 08:10:02PM +0000, Norton, Scott J wrote:
> > How do people run this AIM7 piece of shit? I let it run for over an hour
> > and it generated exactly 0 numbers, it just sits there eating cpu-time
> > and creating a racket from my pantry.
> 
> ./reaim -s100  -e2000 -t -j100 -i100 -f workfile.high_systime
> 
> The reaim.config file contains:
> 
> FILESIZE 10k
> POOLSIZE 1m
> DISKDIR /t0
> DISKDIR /t1
> DISKDIR /t2
> DISKDIR /t3
> DISKDIR /t4
> DISKDIR /t5
> DISKDIR /t6
> DISKDIR /t7
> DISKDIR /t8
> DISKDIR /t9
> DISKDIR /t10
> DISKDIR /t11
> DISKDIR /t12
> DISKDIR /t13
> DISKDIR /t14
> DISKDIR /t15
> 
> The way Longman uses this is to create 16 ramdisk filesystems through
> /dev/ram* and then mount those filesystems to the /t* directories.
> Although you could run it through a regular filesystem also. It will use
> whatever you place in the reaim.config file as DISKDIR. You can specify
> one or more DISKDIR directories.

OK, and we're back to creating a racket but not producing useful
numbers; how long is that crap supposed to run before it gives a number?

Surely it can produce a useful number after a few minutes of runtime..
Letting it run for hours is just a waste of time and money.

Note that I'm running this on a WSM-EP with (2*6*2) 24 CPUs and 24G of ram.
