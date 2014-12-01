Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaLAL26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:28:58 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:51251 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaLAL24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:28:56 -0500
Date: Mon, 1 Dec 2014 12:28:44 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, rusty@au1.ibm.com,
        nab@linux-iscsi.org, pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Message-ID: <20141201122844.1f0a0fa8.cornelia.huck@de.ibm.com>
In-Reply-To: <20141201110136.1ff29a67@thinkpad-w530>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
	<20141201092850.GD15607@redhat.com>
	<20141201110136.1ff29a67@thinkpad-w530>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120111-0041-0000-0000-00000250B3DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 11:01:36 +0100
David Hildenbrand <dahi@linux.vnet.ibm.com> wrote:

> > On Mon, Dec 01, 2014 at 09:16:41AM +0100, David Hildenbrand wrote:
> > > > Based on patch by Cornelia Huck.
> > > > 
> > > > Note: for consistency, and to avoid sparse errors,
> > > >       convert all fields, even those no longer in use
> > > >       for virtio v1.0.
> > > > 
> > > > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ...
> > > > 
> > > > -static unsigned int features[] = {
> > > > +static unsigned int features_legacy[] = {
> > > >  	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> > > >  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
> > > >  	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
> > > >  	VIRTIO_BLK_F_MQ,
> > > > +}
> > > > +;
> > > > +static unsigned int features[] = {
> > > > +	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> > > > +	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
> > > > +	VIRTIO_BLK_F_TOPOLOGY,
> > > > +	VIRTIO_BLK_F_MQ,
> > > > +	VIRTIO_F_VERSION_1,
> > > 
> > > We can fit this into less lines, like done for features_legacy.
> > 
> > Wrt packing code more tightly, I did it like this to
> > make it easier to compare the arrays.
> > Each flag is on the same line in original and new array.
> 
> This just looks inconsistent to me.
> 
> 1. features_legacy is tightly packed
> 2. half of features is tightly packed
> 
> So either all tightly packed or put every item on a single line. At least
> that's what I would do :)

I agree with the reasoning that this makes it easy to compare legacy
vs. standard at a glance, so I vote for keeping it this way.

