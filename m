Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3AQR0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:26:33 -0500
Received: from myspam1.stec-inc.com ([210.19.18.169]:43067 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751343Ab3AQR0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:26:31 -0500
X-ASG-Debug-ID: 1358443586-053ea90dcf1bd720001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: Kent Overstreet <koverstreet@google.com>
CC: "thornber@redhat.com" <thornber@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Date: Fri, 18 Jan 2013 01:17:17 +0800
Subject: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Topic: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
X-ASG-Orig-Subj: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Index: Ac30p0ulTDlP4rV5QxKVDV9cTlxZGwAKya1g
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7247@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
 <20130117113940.GI10411@moria.home.lan>
In-Reply-To: <20130117113940.GI10411@moria.home.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1358443586
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120125
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for a prompt reply.
 
> Suppose I could fill out the bcache version...
> 
> On Thu, Jan 17, 2013 at 05:52:00PM +0800, Amit Kale wrote:
> > Hi Joe, Kent,
> >
> > [Adding Kent as well since bcache is mentioned below as one of the
> > contenders for being integrated into mainline kernel.]
> >
> > My understanding is that these three caching solutions all have three
> principle blocks.
> > 1. A cache block lookup - This refers to finding out whether a block
> was cached or not and the location on SSD, if it was.
> > 2. Block replacement policy - This refers to the algorithm for
> replacing a block when a new free block can't be found.
> > 3. IO handling - This is about issuing IO requests to SSD and HDD.
> > 4. Dirty data clean-up algorithm (for write-back only) - The dirty
> data clean-up algorithm decides when to write a dirty block in an SSD
> to its original location on HDD and executes the copy.
> >
> > When comparing the three solutions we need to consider these aspects.
> > 1. User interface - This consists of commands used by users for
> creating, deleting, editing properties and recovering from error
> conditions.
> > 2. Software interface - Where it interfaces to Linux kernel and
> applications.
> 
> Both done with sysfs, at least for now.

sysfs is the user interface. Bcache creates a new block device. So it interfaces to Linux kernel at block device layer. HDD and SSD interfaces would at using submit_bio (pl. correct if this is wrong).

> 
> > 3. Availability - What's the downtime when adding, deleting caches,
> making changes to cache configuration, conversion between cache modes,
> recovering after a crash, recovering from an error condition.
> 
> All of that is done at runtime, without any interruption. bcache
> doesn't distinguish between clean and unclean shutdown, which is nice
> because it means the recovery code gets tested. Registering a cache
> device takes on the order of half a second, for a large (half terabyte)
> cache.

Since a new device is created, you need to bring down applications the first time a cache is created. There-onwards it would be online. Similarly applications need to be brought down when deleting a cache. Fstab changes etc also need to be done. My guess is all this requires some effort and understanding by a system administrator. Does fstab work without any manual editing if it contains labes instead of device paths?

> 
> > 4. Security - Security holes, if any.
> 
> Hope there aren't any!

All the three caches can be operated only as root. So as long as there are no bugs, there is no need to worry about security loopholes.

> 
> > 5. Portability - Which HDDs, SSDs, partitions, other block devices it
> works with.
> 
> Any block device.
> 
> > 6. Persistence of cache configuration - Once created does the cache
> configuration stay persistent across reboots. How are changes in device
> sequence or numbering handled.
> 
> Persistent. Device nodes are not stable across reboots, same as say
> scsi devices if they get probed in a different order. It does persist a
> label in the backing device superblock which can be used to implement
> stable device nodes.

Can this be embedded in a udev script so that the configuration becomes persistent regardless of probing order? What happens if either SSD or HDD are absent when a system comes up? Does it work with iSCSI HDDs? iSCSi HDDs can be tricky during shutdown, specifically if the iSCSI device goes offline before a cache saves metadata.

> > 7. Persistence of cached data - Does cached data remain across
> reboots/crashes/intermittent failures. Is the "sticky"ness of data
> configurable.
> 
> Persists across reboots. Can't be switched off, though it could be if
> there was any demand.

Believe me, enterprise customers do require a cache to be non-persistent. This is because of a paranoia that HDD and SSD may go out of sync after a shutdown and before a reboot. This is primarily in an environment with a large number of HDDs accessed through a complicated iSCSI based setup perhaps with software RAID.


> > 8. SSD life - Projected SSD life. Does the caching solution cause too
> much of write amplification leading to an early SSD failure.
> 
> With LRU, there's only so much you can do to work around the SSD's FTL,
> though bcache does try; allocation is done in terms of buckets, which
> are on the order of a megabyte (configured when you format the cache
> device). Buckets are written to sequentially, then rewritten later all
> at once (and it'll issue a discard before rewriting a bucket if you
> flip it on, it's not on by default because TRIM = slow).
> 
> Bcache also implements fifo cache replacement, and with that write
> amplification should never be an issue.

Most SSDs contain a fairly sophisticated FTL doing wear-leveling. Wear-leveling only helps by evenly balancing over-writes across an entire SSD. Do you have statistics on how many SSD writes are generated per block read from or written to HDD? Metadata writes should be done only for the affected sectors, or else they contribute to more SSD internal writes. There is also a common debate on whether writing a single sector is more beneficial compared writing a whole block containing that sector.

> 
> > 9. Performance - Throughput is generally most important. Latency is
> also one more performance comparison point. Performance under different
> load classes can be measured.
> > 10. ACID properties - Atomicity, Concurrency, Idempotent, Durability.
> Does the caching solution have these typical transactional database or
> filesystem properties. This includes avoiding torn-page problem amongst
> crash and failure scenarios.
> 
> Yes.
> 
> > 11. Error conditions - Handling power failures, intermittent and
> permanent device failures.
> 
> Power failures and device failures yes, intermittent failures are not
> explicitly handled.

The IO completion guarantee offered on intermittent failures should be as good as HDD.

> 
> > 12. Configuration parameters for tuning according to applications.
> 
> Lots. The most important one is probably sequential bypass - you don't
> typically want to cache your big sequential IO, because rotating disks
> do fine at that. So bcache detects sequential IO and bypasses it with a
> configurable threshold.
> 
> There's also stuff for bypassing more data if the SSD is overloaded -
> if you're caching many disks with a single SSD, you don't want the SSD
> to be the bottleneck. So it tracks latency to the SSD and cranks down
> the sequential bypass threshold if it gets too high.

That's interesting. I'll definitely want to read this part of the source code.

> 
> > We'll soon document EnhanceIO behavior in context of these aspects.
> We'll appreciate if dm-cache and bcache is also documented.
> >
> > When comparing performance there are three levels at which it can be
> > measured 1. Architectural elements 1.1. Throughput for 100% cache hit
> > case (in absence of dirty data clean-up)
> 
> North of a million iops.
> 
> > 1.2. Throughput for 0% cache hit case (in absence of dirty data
> > clean-up)
> 
> Also relevant whether you're adding the data to the cache. I'm sure
> bcache is slightly slower than the raw backing device here, but if it's
> noticable it's a bug (I haven't benchmarked that specifically in ages).
> 
> > 1.3. Dirty data clean-up rate (in absence of IO)
> 
> Background writeback is done by scanning the btree in the background
> for dirty data, and then writing it out in lba order - so the writes
> are as sequential as they're going to get. It's fast.

Great.

Thanks.
-Amit
> 
> > 2. Performance of architectural elements combined 2.1. Varying mix of
> > read/write, sustained performance.
> 
> Random write performance is definitely important, as there you've got
> to keep an index up to date on stable storage (if you want to handle
> unclean shutdown, anyways). Making that fast is non trivial. Bcache is
> about as efficient as you're going to get w.r.t. metadata writes,
> though.
> 
> > 3. Application level testing - The more real-life like benchmark we
> work with, the better it is.

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
