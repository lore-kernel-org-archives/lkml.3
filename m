Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935258AbaH0Ppy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:45:54 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:52552 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523AbaH0Ppw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:45:52 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5 v2] brd: partition fixes
In-Reply-To: <53FDF7AD.5000709@plexistor.com>
References: <53FDF7AD.5000709@plexistor.com>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Wed, 27 Aug 2014 19:45:48 +0400
Message-ID: <87wq9u7x77.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 18:22:21 +0300, Boaz Harrosh <boaz@plexistor.com> wrote:
> Jens Hi
> 
> What do you intend to do with these fixes? These are real bugs on devices
> shipped for a while now. I think they need to go into current 3.17-rcX Kernel.
> 
> If not then lets please put them in for-next
> [This set is for linux-block.git/for-next, tell me if you need one ontop
>  of for-linus]
> 
It looks like I've missed your context. Please elaborate your use-case
> [v2]
> Based on Jens's linux-next [30e996a] incorporating the brd patch by Dmitry Monakhov.
> Dmitry has introduced a new part_show parameter, this parameter is now
> removed
  In which commit or kernel-tree this parameter was removed?
> and we always "part_show=1".
> Scripts that did part_show=1 will work just the same but will display a
> message in logs. This is harmless. (And scripts can be modified to
> remove this parameter)
  Which script are you talking about? Why you want use it?

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
