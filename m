Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaKZNUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:20:22 -0500
Received: from mx6-phx2.redhat.com ([209.132.183.39]:44620 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaKZNUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:20:21 -0500
Date: Wed, 26 Nov 2014 08:19:32 -0500 (EST)
From: Rodrigo Freire <rfreire@redhat.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        Felix Fietkau <nbd@openwrt.org>, dwmw2@infradead.org,
        Herton Krzesinski <hkrzesin@redhat.com>
Message-ID: <1417070032.4547583.1417007972343.JavaMail.zimbra@redhat.com>
In-Reply-To: <20141126072147.GO3212@norris-Latitude-E6410>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com> <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com> <20140909170231.GA14429@logfs.org> <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com> <20141105202303.GN23619@ld-irv-0074> <2086372266.7454667.1415535533979.JavaMail.zimbra@redhat.com> <1874445287.7454806.1415535792984.JavaMail.zimbra@redhat.com> <20141126072147.GO3212@norris-Latitude-E6410>
Subject: Re: [PATCH v3 3/3] mtd: block2mtd: Removes PAGE_MASK as a index to
 partition size
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: block2mtd: Removes PAGE_MASK as a index to partition size
Thread-Index: zAPb7IZBowll7g0xcUBjyikjok2wGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Brian Norris" <computersforpeace@gmail.com>
Sent: Wednesday, November 26, 2014 5:21:47 AM
Subject: Re: [PATCH v3 3/3] mtd: block2mtd: Removes PAGE_MASK as a index to
partition size

> On Sun, Nov 09, 2014 at 07:23:12AM -0500, Rodrigo Freire wrote:
> > PAGE_MASK is no longer needed with the new term.

> This isn't too descriptive. What you probably mean is that we assume the
> erase size is always larger than PAGE_SIZE.

> > This patch keeps the device size aligned with the erase_size.
> >
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
> > Signed-off-by: Herton Krzesinski <herton@redhat.com>
> > ---
> > V3: Separated on a single patch
> > --- a/drivers/mtd/devices/block2mtd.c 2014-11-07 17:40:58.688747820 -0200
> > +++ b/drivers/mtd/devices/block2mtd.c 2014-11-07 17:41:28.054750893 -0200
> > @@ -291,8 +291,7 @@ static struct block2mtd_dev *add_device(
> > goto err_destroy_mutex;
> >
> > dev->mtd.name = name;
> > -
> > - dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
> > + dev->mtd.size = dev->blkdev->bd_inode->i_size & ~(erase_size - 1);

> You never guaranteed that erase_size is a power of two, so this doesn't
> necessarily mask the way you'd like...

> But also, why is this even necessary? I see that we should already have
> errored out if this was actually significant, since we have above:

> if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
> pr_err("erasesize must be a divisor of device size\n");
> goto err_free_block2mtd;
> }

Hello Brian, and thanks for the review.

Honestly, I'd leave that untouched, but Jörn pointed that it could be a issue at https://lkml.org/lkml/2014/9/9/680

I'd happily let it go without this patch 3, unless Jörg wants to state otherwise.
