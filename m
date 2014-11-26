Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaKZOvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:51:20 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:35169 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaKZOvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:51:18 -0500
Date: Wed, 26 Nov 2014 15:51:03 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 38/42] virtio_scsi: v1.0 support
Message-ID: <20141126155103.1f6725ce.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-39-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-39-git-send-email-mst@redhat.com>
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
x-cbid: 14112614-0025-0000-0000-0000029A1584
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:44:08 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Note: for consistency, and to avoid sparse errors,
>   convert all fields, even those no longer in use
>   for virtio v1.0.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_scsi.h | 32 +++++++++++++++-------------
>  drivers/scsi/virtio_scsi.c  | 51 ++++++++++++++++++++++++++++-----------------
>  2 files changed, 49 insertions(+), 34 deletions(-)
> 

> @@ -158,7 +158,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  		sc, resp->response, resp->status, resp->sense_len);
> 
>  	sc->result = resp->status;
> -	virtscsi_compute_resid(sc, resp->resid);
> +	virtscsi_compute_resid(sc, __virtio32_to_cpu(vscsi->vdev, resp->resid));

Confused. Don't you need the non-underscore versions if you pass in a
vdev as first parameter?

>  	switch (resp->response) {
>  	case VIRTIO_SCSI_S_OK:
>  		set_host_byte(sc, DID_OK);

