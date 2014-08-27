Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935583AbaH0Ryz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:54:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:53808 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933813AbaH0Ryx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:54:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,412,1406617200"; 
   d="scan'208";a="564285158"
Date: Wed, 27 Aug 2014 13:53:27 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Dmitry Monakhov <dmonakhov@openvz.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/5] brd: Add getgeo to block ops
Message-ID: <20140827175327.GF3285@linux.intel.com>
References: <53FDF7AD.5000709@plexistor.com>
 <53FDF919.6020006@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FDF919.6020006@plexistor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 06:28:25PM +0300, Boaz Harrosh wrote:
> We set all hd_geometry members to 1, because this way fdisk
> math will not try its crazy geometry math and get stuff totally wrong.
> 
> I was trying to get some values that will make fdisk Want to align
> first sector on 4K (like 8, 16, 20, ... sectors) but nothing worked,
> I searched the net the math is not your regular simple multiplication
> at all.
> 
> If you managed to get these please tell me. I would love to solve
> this.
> 
> But for now we use 4k physical sectors for fixing fdisk alignment
> issues, and setting these here to something that will not make
> fdisk serve us with crazy numbers.

Are you saying that fdisk ignores the 4k physical sectors (that you set up
in patch 5/5) in favour of the geometry exposed here?  That doesn't make
sense to me, since it would misalign 4k-physical ATA drives if it did.

I don't see anywhere else in the kernel reporting (1,1,1).  The most common
form to fake a geometry uses (64, 32, x), including SCSI.
