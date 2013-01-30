Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3A3T54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:57:56 -0500
Received: from myspam1.stec-inc.com ([210.19.18.169]:48732 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756792Ab3A3T5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:57:54 -0500
X-ASG-Debug-ID: 1359575869-053ea90dcf1dfdd0001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: Pavel Machek <pavel@ucw.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 31 Jan 2013 03:56:06 +0800
Subject: RE: Announcement: STEC EnhanceIO SSD caching software for Linux
 kernel
Thread-Topic: Announcement: STEC EnhanceIO SSD caching software for Linux
 kernel
X-ASG-Orig-Subj: RE: Announcement: STEC EnhanceIO SSD caching software for Linux
 kernel
Thread-Index: Ac3+5kvpZIIYZdBSQQae4+p6KWV93AAPRdDg
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6329@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <20130130123630.GA19069@amd.pavel.ucw.cz>
In-Reply-To: <20130130123630.GA19069@amd.pavel.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1359575869
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.121353
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Pavel Machek [mailto:pavel@ucw.cz]
> Sent: Wednesday, January 30, 2013 4:37 AM
> To: Amit Kale
> Cc: LKML
> Subject: Re: Announcement: STEC EnhanceIO SSD caching software for
> Linux kernel
> 
> Hi!
> 
> > EnhanceIO driver is based on EnhanceIO SSD caching software product
> developed by STEC Inc. EnhanceIO was derived from Facebook's open
> source Flashcache project. EnhanceIO uses SSDs as cache devices for
> traditional rotating hard disk drives (referred to as source volumes
> throughout this document).
> >
> > EnhanceIO can work with any block device, be it an entire physical
> disk, an individual disk partition,  a RAIDed DAS device, a SAN volume,
> a device mapper volume or a software RAID (md) device.
> >
> > The source volume to SSD mapping is a set-associative mapping based
> on the source volume sector number with a default set size (aka
> associativity) of 512 blocks and a default block size of 4 KB.  Partial
> cache blocks are not used.
> > The default value of 4 KB is chosen because it is the common I/O
> block
> > size of most storage systems.  With these default values, each cache
> > set is 2 MB (512 *
> > 4 KB).  Therefore, a 400 GB SSD will have a little less than 200,000
> cache sets because a little space is used for storing the meta data on
> the SSD.
> >
> > EnhanceIO supports three caching modes: read-only, write-through, and
> write-back and three cache replacement policies: random, FIFO, and LRU.
> >
> > Read-only caching mode causes EnhanceIO to direct write IO requests
> > only to HDD. Read IO requests are issued to HDD and the data read
> from
> > HDD is stored on SSD. Subsequent Read requests for the same blocks
> are
> > carried out from SSD, thus reducing their latency by a substantial
> > amount.
> 
> What are the requirements for the SSD? I have 500GB 2.5" HDD in the
> notebook... and it starts to be slightly slow for git. Would cheap 8GB
> USB stick be useful thing to cache at? (USB sticks have reasonably fast
> "seek", but reads are in 20MB/sec range and writes are very
> slow.)

Hi Pavel,

Our testing primarily covered 100GB+ SSDs due to our focus on enterprise market. 8GB will work, but 500:8 is about 60times. Our recommendation is to keep SSD:HDD ratio between 1:5 and 1:10. I'll be most interested in knowing your findings.

Thanks.
-Amit

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
