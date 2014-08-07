Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaHGSUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 14:20:51 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:54661 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaHGSUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 14:20:50 -0400
Date: Thu, 7 Aug 2014 19:20:32 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/4 v2] brd: Add getgeo to block ops
Message-ID: <20140807192032.70e71fa7@alan.etchedpixels.co.uk>
In-Reply-To: <53E3871C.4020008@plexistor.com>
References: <53E21125.9080308@plexistor.com>
	<53E211D9.7030102@plexistor.com>
	<53E3871C.4020008@plexistor.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2014 17:03:08 +0300
Boaz Harrosh <boaz@plexistor.com> wrote:

> From: Boaz Harrosh <boaz@plexistor.com>
> 
> Some programs like fdisk, require HDIO_GETGEO to work, which requires we
> implement getgeo.
> 
> We set all hd_geometry members to 1, because this way fdisk
> math will not try its crazy geometry math and get stuff totally wrong.

If you are running a new storage system for god sake don't use DOS
partitioning, use GPT or something sane.

> +static int brd_getgeo(struct block_device *bd, struct hd_geometry *geo)
> +{
> +	/* Just tell fdisk to get out of the way. The math here is so
> +	 * convoluted and does not make any sense at all. With all 1s
> +	 * The math just gets out of the way.
> +	 * NOTE: I was trying to get some values that will make fdisk
> +	 * Want to align first sector on 4K (like 8, 16, 20, ... sectors) but
> +	 * nothing worked, I searched the net the math is not your regular
> +	 * simple multiplication at all. If you managed to get these please
> +	 * fix here. For now we use 4k physical sectors for this
> +	 */
> +	geo->heads = 1;
> +	geo->sectors = 1;
> +	geo->cylinders = 1;
> +	return 0;

This is then going to blow up on your with some other tool. Fix fdisk
instead. Lying to apps generally ends up like children lying to parents -
the lie gets more complicated to keep up each case you find until it
breaks.

Alan
