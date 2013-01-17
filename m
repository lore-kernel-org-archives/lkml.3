Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab3AQJz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:55:56 -0500
Received: from myspam1.stec-inc.com ([210.19.18.169]:48844 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759375Ab3AQJzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:55:51 -0500
X-ASG-Debug-ID: 1358416546-053ea90dcf1bcd50001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: "thornber@redhat.com" <thornber@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>
CC: Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Date: Thu, 17 Jan 2013 17:52:00 +0800
Subject: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Topic: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
X-ASG-Orig-Subj: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Index: Ac3z1qKfaXQWfd1OSee2AxVfFaQpsQAvAktA
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
In-Reply-To: <20130116104546.GA3869@raspberrypi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1358416546
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120095
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe, Kent,

[Adding Kent as well since bcache is mentioned below as one of the contenders for being integrated into mainline kernel.]

My understanding is that these three caching solutions all have three principle blocks.
1. A cache block lookup - This refers to finding out whether a block was cached or not and the location on SSD, if it was.
2. Block replacement policy - This refers to the algorithm for replacing a block when a new free block can't be found.
3. IO handling - This is about issuing IO requests to SSD and HDD.
4. Dirty data clean-up algorithm (for write-back only) - The dirty data clean-up algorithm decides when to write a dirty block in an SSD to its original location on HDD and executes the copy. 

When comparing the three solutions we need to consider these aspects.
1. User interface - This consists of commands used by users for creating, deleting, editing properties and recovering from error conditions.
2. Software interface - Where it interfaces to Linux kernel and applications.
3. Availability - What's the downtime when adding, deleting caches, making changes to cache configuration, conversion between cache modes, recovering after a crash, recovering from an error condition.
4. Security - Security holes, if any.
5. Portability - Which HDDs, SSDs, partitions, other block devices it works with.
6. Persistence of cache configuration - Once created does the cache configuration stay persistent across reboots. How are changes in device sequence or numbering handled.
7. Persistence of cached data - Does cached data remain across reboots/crashes/intermittent failures. Is the "sticky"ness of data configurable.
8. SSD life - Projected SSD life. Does the caching solution cause too much of write amplification leading to an early SSD failure.
9. Performance - Throughput is generally most important. Latency is also one more performance comparison point. Performance under different load classes can be measured.
10. ACID properties - Atomicity, Concurrency, Idempotent, Durability. Does the caching solution have these typical transactional database or filesystem properties. This includes avoiding torn-page problem amongst crash and failure scenarios.
11. Error conditions - Handling power failures, intermittent and permanent device failures.
12. Configuration parameters for tuning according to applications.

We'll soon document EnhanceIO behavior in context of these aspects. We'll appreciate if dm-cache and bcache is also documented.

When comparing performance there are three levels at which it can be measured
1. Architectural elements
1.1. Throughput for 100% cache hit case (in absence of dirty data clean-up)
1.2. Throughput for 0% cache hit case (in absence of dirty data clean-up)
1.3. Dirty data clean-up rate (in absence of IO)
2. Performance of architectural elements combined
2.1. Varying mix of read/write, sustained performance.
3. Application level testing - The more real-life like benchmark we work with, the better it is.

Thanks.
-Amit

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of thornber@redhat.com
> Sent: Wednesday, January 16, 2013 4:16 PM
> To: device-mapper development
> Cc: Mike Snitzer; LKML
> Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching
> software for Linux kernel
> 
> Hi Amit,
> 
> I'll look through EnhanceIO this week.
> 
> There are several cache solutions out there; bcache, my dm-cache and
> EnhanceIO seeming to be the favourites.  In suspect none of them are
> without drawbacks, so I'd like to see if we can maybe work together.
> 
> I think the first thing we need to do is make it easy to compare the
> performance of these impls.
> 
> I'll create a branch in my github tree with all three caches in.  So
> it's easy to build a kernel with them.  (Mike's already combined dm-
> cache and bcache and done some preliminary testing).
> 
> We've got some small test scenarios in our test suite that we run [1].
> They certainly flatter dm-cache since it was developed using these.
> It would be really nice if you could describe and provide scripts for
> your test scenarios.  I'll integrate them with the test suite, and then
> I can have some confidence that I'm seeing EnhanceIO in its best light.
> 
> The 'transparent' cache issue is a valid one, but to be honest a bit
> orthogonal to cache.  Integrating dm more closely with the block layer
> such that a dm stack can replace any device has been discussed for
> years and I know Alasdair has done some preliminary design work on
> this.  Perhaps we can use your requirement to bump up the priority on
> this work.
> 
> On Tue, Jan 15, 2013 at 09:19:10PM +0800, Amit Kale wrote:
> > 5. We have designed our writeback architecture from scratch.
> > Coalescing/bunching together of metadata writes and cleanup is much
> > improved after redesigning of the EnhanceIO-SSD interface. The DM
> > interface would have been too restrictive for this. EnhanceIO uses
> set
> > level locking, which improves parallelism of IO, particularly for
> > writeback.
> 
> I sympathise with this; dm-cache would also like to see a higher level
> view of the io, rather than being given the ios to remap one by one.
> Let's start by working out how much of a benefit you've gained from
> this and then go from there.
> 
> > PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
> >
> > This electronic transmission, and any documents attached hereto, may
> > contain confidential, proprietary and/or legally privileged
> > information. The information is intended only for use by the
> recipient
> > named above. If you received this electronic message in error, please
> > notify the sender and delete the electronic message. Any disclosure,
> > copying, distribution, or use of the contents of information received
> > in error is strictly prohibited, and violators will be pursued
> > legally.
> 
> Please do not use this signature when sending to dm-devel.  If there's
> proprietary information in the email you need to tell people up front
> so they can choose not to read it.
> 
> - Joe
> 
> 
>   [1] https://github.com/jthornber/thinp-test-
> suite/tree/master/tests/cache
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
