Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaHGPVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:21:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbaHGPVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:21:21 -0400
Date: Thu, 7 Aug 2014 17:21:12 +0200
From: Karel Zak <kzak@redhat.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Boaz Harrosh <openosd@gmail.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] brd: Request from fdisk 4k alignment
Message-ID: <20140807152112.GD9401@x2.net.home>
References: <53E21125.9080308@plexistor.com>
 <53E21317.7080403@plexistor.com>
 <1407362634.2869.2.camel@rzwisler-mobl1.amr.corp.intel.com>
 <53E36E53.3090008@gmail.com>
 <20140807130042.GB9401@x2.net.home>
 <53E385BE.40100@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E385BE.40100@plexistor.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 04:57:18PM +0300, Boaz Harrosh wrote:

> I was not saying that fdisk is wrong. I was saying that if my block driver
> was *not* exporting 4K physical sectors through limits.physical_block_size

 yep, sorry (it's probably bad idea to read emails and listen to talks on
 conference..)

> then fdisk would be happy to not align my partition start on 4k and would
> give me funny values like 34 for first sector which makes my device unusable
> because in direct_access() API we must absolutely have 4K aligned partitions.
> 
> >> to miss-align my partitions. Depending on size maybe not the very first one but the
> >> consecutive ones easily.
> > 
> >  it would be nice to have usable bug report...
> > 
> 
> Setting limits.physical_block_size = 4k; was the only way I found that could cause
> fdisk to default to 4k alignment.

 fdisk uses physical sector size or minimal I/O size (greater value wins)

> I was trying to play with the  heads, sectors, cylinders; values but none I tried

 don't play with CHS, that's waste of time and it's completely ignored
 by fdisk by default

> would cause an alignment of 4k, not even of the first partition start.
> 
> Please advise what I can do?

 IMHO you're right with your patch (alignment offset is IMHO bad way).
 It's all (brd) about pages, is there any reason to use something else
 for I/O limits?

 It would be also nice to set minimal and optimal io size, zero values
 in this case means (for userspace) that the device does not provide
 any I/O information to system. It's normal for old hw disks and then
 we use some built-in defaults, but I don't see a reason to do the
 same for virtual devices. 

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
