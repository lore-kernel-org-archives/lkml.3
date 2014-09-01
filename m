Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaIAKP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:15:59 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49010 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaIAKP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:15:58 -0400
Message-ID: <54044759.9080103@gmail.com>
Date: Mon, 01 Sep 2014 13:15:53 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5 v2] brd: partition fixes
References: <53FDF7AD.5000709@plexistor.com>
In-Reply-To: <53FDF7AD.5000709@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 06:22 PM, Boaz Harrosh wrote:
> Jens Hi
> 
> What do you intend to do with these fixes? These are real bugs on devices
> shipped for a while now. I think they need to go into current 3.17-rcX Kernel.
> 

Jens hi

I have seen that the brd patch went into rc3.

I should insist then, that these patches go into this rc cycle ASAP.
For one they fix real *hard* unexpected bugs with brd that make it trash data.

But specially because the patch to brd that just went into Kernel introduces
a wrong module parameter "show_part" which must be removed. If we release a Kernel
with it, it will be pain, we will need to deprecate it which is long and annoying
procedure. It is wrong because it must be always on. Pleas see below

This patchset is based on what just went into Kernel.
Also on git here: git://git.open-osd.org/pmem.git brd-partitions branch

[http://git.open-osd.org/gitweb.cgi?p=pmem.git;a=shortlog;h=refs/heads/brd-partitions]

Thanks
Boaz

> If not then lets please put them in for-next
> [This set is for linux-block.git/for-next, tell me if you need one ontop
>  of for-linus]
> 
> [v2]
> Based on Jens's linux-next [30e996a] incorporating the brd patch by Dmitry Monakhov.
> Dmitry has introduced a new part_show parameter, this parameter is now removed
> and we always "part_show=1".
> Scripts that did part_show=1 will work just the same but will display a
> message in logs. This is harmless. (And scripts can be modified to
> remove this parameter)
> 
> [v1]
> Current situation is that any attempt to use partitions with brd device would
> create the partition but then any use will trash the data.
> 
> See: http://www.spinics.net/lists/linux-scsi/msg76737.html
> 
> So these patches fixes up all the problems we saw with the code, but not sacrificing
> any of the old fixtures. See [patch 4/5] for more explanations.
> 
> list of patches:
> [PATCH 1/5] axonram: Fix bug in direct_access
> [PATCH 2/5] Change direct_access calling convention
> 
>     These are Matthew's patches from the DAX series which fixes the interface to
>     direct_access taking into account the partition offset. It must be applied
>     here for partitions to work with direct_access() API.
> 
> [PATCH 3/5] brd: Add getgeo to block ops
> 
>     This one is needed by fdisk, otherwise it just asks extra questions
> 
> [PATCH 4/5] brd: Fix all partitions BUGs
> [PATCH 5/5] brd: Request from fdisk 4k alignment
> 
> Thanks
> Boaz
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

