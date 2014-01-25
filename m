Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaAYKws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 05:52:48 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:23618 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbaAYKwr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 05:52:47 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArohAKyW41JXQwn9/2dsb2JhbABaKIJkOKdGlVMCAoEIF3SCJQEBAQMBJy8jBQsIAxguOR4GE4d9DAHJFBeOKTEzB4Q4AQOJRo5gAZIegzovgSw
Date: Sat, 25 Jan 2014 10:53:58 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mtd: block2mtd: char mtd major check
Message-Id: <20140125105358.f702dec03b3728270f5ca4d1@skynet.be>
In-Reply-To: <20140124214836.GA14088@localhost>
References: <20140123204947.fc1c03dc0a1624d3347b3837@skynet.be>
	<20140124214836.GA14088@localhost>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014 19:10:11 -0300
Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:

> On Thu, Jan 23, 2014 at 08:49:47PM +0100, Fabian Frederick wrote:
> > Deny use of a char mtd device to map as a block device.
> > 
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  drivers/mtd/devices/block2mtd.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
> > index d9fd87a..0efee5b 100644
> > --- a/drivers/mtd/devices/block2mtd.c
> > +++ b/drivers/mtd/devices/block2mtd.c
> > @@ -244,7 +244,8 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
> >  	}
> >  	dev->blkdev = bdev;
> >  
> > -	if (MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) {
> > +	if ((MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) ||
> > +	    (MAJOR(bdev->bd_dev) == MTD_CHAR_MAJOR)) {
> >  		pr_err("attempting to use an MTD device as a block device\n");
> >  		goto devinit_err;
> >  	}
> > -- 
> > 1.8.1.4
> 
> Now that the changes are separated on a per-patch basis they're much
> much easier to review. Thanks!
> 
> Regarding this changes, it seems to me it's not needed. Are you sure
> you can attach "block2mtd" to a char MTD device?
> 
> That would be odd, given this function calls blkdev_get_by_{path/dev};
> which will check the device is of block type in the first place.
> 
You're absoletly right.Thanks for your time checking these small patches.
As only patch 2 seems useful , I've sent version 2 with new error names.

Regards,
Fabian

> What's your motivation for this change?
> -- 
> Ezequiel García, Free Electrons
> Embedded Linux, Kernel and Android Engineering
> http://free-electrons.com
