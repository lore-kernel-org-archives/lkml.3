Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaKZO5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:57:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaKZO5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:57:08 -0500
Date: Wed, 26 Nov 2014 16:56:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 38/42] virtio_scsi: v1.0 support
Message-ID: <20141126145642.GA9359@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-39-git-send-email-mst@redhat.com>
 <20141126155103.1f6725ce.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126155103.1f6725ce.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 03:51:03PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:44:08 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Note: for consistency, and to avoid sparse errors,
> >   convert all fields, even those no longer in use
> >   for virtio v1.0.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio_scsi.h | 32 +++++++++++++++-------------
> >  drivers/scsi/virtio_scsi.c  | 51 ++++++++++++++++++++++++++++-----------------
> >  2 files changed, 49 insertions(+), 34 deletions(-)
> > 
> 
> > @@ -158,7 +158,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
> >  		sc, resp->response, resp->status, resp->sense_len);
> > 
> >  	sc->result = resp->status;
> > -	virtscsi_compute_resid(sc, resp->resid);
> > +	virtscsi_compute_resid(sc, __virtio32_to_cpu(vscsi->vdev, resp->resid));
> 
> Confused. Don't you need the non-underscore versions if you pass in a
> vdev as first parameter?

Ouch, this built because vscsi->vdev is true.
thanks!

> >  	switch (resp->response) {
> >  	case VIRTIO_SCSI_S_OK:
> >  		set_host_byte(sc, DID_OK);
