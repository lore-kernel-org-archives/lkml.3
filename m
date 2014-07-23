Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaGWNRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:17:43 -0400
Received: from cpc2-cwma8-2-0-cust224.7-3.cable.virginm.net ([82.20.154.225]:58018
	"EHLO alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751754AbaGWNRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:17:41 -0400
Date: Wed, 23 Jul 2014 14:17:21 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Linda Walsh <lkml@tlinx.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Howto tell kernel to use 4096 as granularity & minimum size?
Message-ID: <20140723141721.3d374d87@alan.etchedpixels.co.uk>
In-Reply-To: <53CD7BE2.3040909@tlinx.org>
References: <53CC0EAA.2010202@tlinx.org>
	<20140720222818.GM4453@dastard>
	<53CD7BE2.3040909@tlinx.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014 13:45:22 -0700
Linda Walsh <lkml@tlinx.org> wrote:

> Dave Chinner wrote:
> >
> >> I can partition the disk and setup the allocation size
> >> to 4096, but I'd like to tell the kernel to use a
> >> virtual-size of 4096 for the sector as an additional
> >> performance 'hint', so nothing will even try to use
> >> smaller i/o's than that.
> >>     
> >
> > Just format the filesystem with 4k sector size.
> ---
>     Good idea,  though.. I wanted to set it for the whole "disk"(array)
> as it (multiple 4T drives) will be subdivided into multiple filesystems
> and have lvm and a partition table under the file system(s),
> so telling the kernel to only do 4K alloc+io's to the whole thing
> would cover the most with the least.

Also before you format it read the specification if you are using SATA
drives. The disk is not necessarily aligned so that the physical/logical
block boundary is as you'd expect. Some devices have a partial physical
sector at the start in order to make it happen to work nicely with legacy
software.

Good fdisk tools know about this. It's in the ATA8 specification for
identify.

Alan
