Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3BFSVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:21:38 -0500
Received: from [1.9.68.9] ([1.9.68.9]:40325 "HELO mysmtp1.stec-inc.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1754960Ab3BFSVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:21:37 -0500
X-ASG-Debug-ID: 1360174893-053ea90dcf233d10001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 7 Feb 2013 02:19:44 +0800
Subject: Update to EnhanceIO SSD caching software for Linux kernel
Thread-Topic: Update to EnhanceIO SSD caching software for Linux kernel
X-ASG-Orig-Subj: Update to EnhanceIO SSD caching software for Linux kernel
Thread-Index: Ac4Elon/t62Y/BjkSUOyz09dJGVFAw==
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D66EF@MYMBX.MY.STEC-INC.AD>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1360174893
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.121995
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

STEC is happy to announce an update to EnhanceIO ssd caching software for Linux kernel. Many thanks to kernel community for providing us valuable feedback to improve code and bug reports since the time it was published. The discussion comparing EnhanceIO to other well-known caching solutions: bcache and dm-cache was particularly interesting.  More such discussions will help us all improve our solutions.

Considering that a lot of the kernel community members have been able to use EnhanceIO successfully, we are now marking its status to be beta. We'll be submitting it to staging tree this week. We'll appreciate sign-offs from those who have tested it and recommend its inclusion in the mainline kernel.

On a related note, STEC EnhanceIO product version 1.2 was released this week.
Open source git was derived from and is identical in functionality to the source base of this product. It has undergone an extensive amount of testing by our QA. EnhanceIO open source git natuarally benefits from this testing.

We have done following changes since the last posting
- Corrected the sparse errors ( eg: errors due to address space mismatch ). 
- Updated cli with enable and notify ioctls. Also made the code partially
  checkpatch.pl clean. 
- Code cleanup
- Fixed spin lock initialisation issue during cache create
- Fixed ioctl structure to be compatible on 64 bit kernel with 32 bit user
  space
- Fixed an md create issue

Work to be done
- More cleanups
- Performance measurements and comparisons
- A detailed technical description of EnhanceIO functionality
- Use a patch format or a simple git format instead of current format so that a
  submission to Linux kernel will be possible.

A quick description of EnhanceIO
---------------------------------------------------------------------------------------------
Repository location - git://github.com/stec-inc/EnhanceIO.git
License - GPL
Source - Derived from the source base of EnhanceIO product Current state - Beta.
Ongoing work - More code cleanup, testing, more documentation, performance comparisons.

EnhanceIO driver is based on EnhanceIO SSD caching software product developed by STEC Inc. EnhanceIO was derived from Facebook's open source Flashcache project. EnhanceIO uses SSDs as cache devices for traditional rotating hard disk drives (referred to as source volumes throughout this document).

EnhanceIO can work with any block device, be it an entire physical disk, an individual disk partition,  a RAIDed DAS device, a SAN volume, a device mapper volume or a software RAID (md) device.

The source volume to SSD mapping is a set-associative mapping based on the source volume sector number with a default set size (aka associativity) of 512 blocks and a default block size of 4 KB.  Partial cache blocks are not used.
The default value of 4 KB is chosen because it is the common I/O block size of most storage systems.  With these default values, each cache set is 2 MB (512 *
4 KB).  Therefore, a 400 GB SSD will have a little less than 200,000 cache sets because a little space is used for storing the meta data on the SSD.

EnhanceIO supports three caching modes: read-only, write-through, and write-back and three cache replacement policies: random, FIFO, and LRU.

Read-only caching mode causes EnhanceIO to direct write IO requests only to HDD. Read IO requests are issued to HDD and the data read from HDD is stored on SSD. Subsequent Read requests for the same blocks are carried out from SSD, thus reducing their latency by a substantial amount. 

In Write-through mode - reads are handled similar to Read-only mode.
Write-through mode causes EnhanceIO to write application data to both HDD and SSD. Subsequent reads of the same data benefit because they can be served from SSD.

Write-back improves write latency by writing application requested data only to SSD. This data, referred to as dirty data, is copied later to HDD asynchronously. Reads are handled similar to Read-only and Write-through modes.

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
