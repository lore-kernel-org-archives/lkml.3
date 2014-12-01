Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaLAM4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:56:03 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58226 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaLAM4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:56:00 -0500
Date: Mon, 1 Dec 2014 13:55:52 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 42/46] virtio_scsi: v1.0 support
Message-ID: <20141201135552.01915825.cornelia.huck@de.ibm.com>
In-Reply-To: <20141201125305.GC18106@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-43-git-send-email-mst@redhat.com>
	<20141201135001.142bd29a.cornelia.huck@de.ibm.com>
	<20141201125305.GC18106@redhat.com>
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
x-cbid: 14120112-0013-0000-0000-0000020CBDB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 14:53:05 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Dec 01, 2014 at 01:50:01PM +0100, Cornelia Huck wrote:
> > On Sun, 30 Nov 2014 17:12:47 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > Note: for consistency, and to avoid sparse errors,
> > >   convert all fields, even those no longer in use
> > >   for virtio v1.0.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >  include/linux/virtio_scsi.h | 32 +++++++++++++++-------------
> > >  drivers/scsi/virtio_scsi.c  | 51 ++++++++++++++++++++++++++++-----------------
> > >  2 files changed, 49 insertions(+), 34 deletions(-)
> > > 
> > 
> > > @@ -196,10 +196,13 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
> > >  		break;
> > >  	}
> > > 
> > > -	WARN_ON(resp->sense_len > VIRTIO_SCSI_SENSE_SIZE);
> > > +	WARN_ON(virtio32_to_cpu(vscsi->vdev, resp->sense_len) >
> > > +		VIRTIO_SCSI_SENSE_SIZE);
> > 
> > Introduce a local variable for this? Might make this statement and the
> > min_t statement below easier to read.
> 
> I prefer 1:1 code conversions. We can do refactorings on top.
> Since you mention this line as hard to read, I'll just make it > 80
> chars for now, and trivial line splits can come later.
> OK?

I guess I don't care strongly enough about this, so go ahead.

