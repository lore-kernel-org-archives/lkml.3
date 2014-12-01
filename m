Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaLAMuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:50:24 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:58688 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbaLAMuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:50:18 -0500
Date: Mon, 1 Dec 2014 13:50:01 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 42/46] virtio_scsi: v1.0 support
Message-ID: <20141201135001.142bd29a.cornelia.huck@de.ibm.com>
In-Reply-To: <1417359787-10138-43-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-43-git-send-email-mst@redhat.com>
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
x-cbid: 14120112-0005-0000-0000-0000024A616F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2014 17:12:47 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Note: for consistency, and to avoid sparse errors,
>   convert all fields, even those no longer in use
>   for virtio v1.0.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/virtio_scsi.h | 32 +++++++++++++++-------------
>  drivers/scsi/virtio_scsi.c  | 51 ++++++++++++++++++++++++++++-----------------
>  2 files changed, 49 insertions(+), 34 deletions(-)
> 

> @@ -196,10 +196,13 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  		break;
>  	}
> 
> -	WARN_ON(resp->sense_len > VIRTIO_SCSI_SENSE_SIZE);
> +	WARN_ON(virtio32_to_cpu(vscsi->vdev, resp->sense_len) >
> +		VIRTIO_SCSI_SENSE_SIZE);

Introduce a local variable for this? Might make this statement and the
min_t statement below easier to read.

>  	if (sc->sense_buffer) {
>  		memcpy(sc->sense_buffer, resp->sense,
> -		       min_t(u32, resp->sense_len, VIRTIO_SCSI_SENSE_SIZE));
> +		       min_t(u32,
> +			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
> +			     VIRTIO_SCSI_SENSE_SIZE));
>  		if (resp->sense_len)
>  			set_driver_byte(sc, DRIVER_SENSE);
>  	}

Otherwise looks good to me.

