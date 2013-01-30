Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3A3Mgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:36:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40290 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3A3Mgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:36:37 -0500
Date: Wed, 30 Jan 2013 13:36:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Amit Kale <akale@stec-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Announcement: STEC EnhanceIO SSD caching software for Linux
 kernel
Message-ID: <20130130123630.GA19069@amd.pavel.ucw.cz>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> EnhanceIO driver is based on EnhanceIO SSD caching software product developed by STEC Inc. EnhanceIO was derived from Facebook's open source Flashcache project. EnhanceIO uses SSDs as cache devices for traditional rotating hard disk drives (referred to as source volumes throughout this document).
> 
> EnhanceIO can work with any block device, be it an entire physical disk, an individual disk partition,  a RAIDed DAS device, a SAN volume, a device mapper volume or a software RAID (md) device.
> 
> The source volume to SSD mapping is a set-associative mapping based on the source volume sector number with a default set size (aka associativity) of 512 blocks and a default block size of 4 KB.  Partial cache blocks are not used.
> The default value of 4 KB is chosen because it is the common I/O block size of most storage systems.  With these default values, each cache set is 2 MB (512 *
> 4 KB).  Therefore, a 400 GB SSD will have a little less than 200,000 cache sets because a little space is used for storing the meta data on the SSD.
> 
> EnhanceIO supports three caching modes: read-only, write-through, and write-back and three cache replacement policies: random, FIFO, and LRU.
> 
> Read-only caching mode causes EnhanceIO to direct write IO requests
> only to HDD. Read IO requests are issued to HDD and the data read
> from HDD is stored on SSD. Subsequent Read requests for the same
> blocks are carried out from SSD, thus reducing their latency by a
> substantial amount. 

What are the requirements for the SSD? I have 500GB 2.5" HDD in the
notebook... and it starts to be slightly slow for git. Would cheap 8GB
USB stick be useful thing to cache at? (USB sticks have reasonably
fast "seek", but reads are in 20MB/sec range and writes are very
slow.)

								Pavel  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
