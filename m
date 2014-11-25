Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaKYRxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:53:50 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:51717 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaKYRxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:53:49 -0500
Date: Tue, 25 Nov 2014 18:53:42 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, Pawel Moll <pawel.moll@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 11/42] virtio: add legacy feature table support
Message-ID: <20141125185342.761bf72e.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-12-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-12-git-send-email-mst@redhat.com>
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
x-cbid: 14112517-0009-0000-0000-00000223054F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:42:09 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio blk has some legacy feature bits that modern drivers

virtio-blk

> must not negotiate, but are needed for old legacy hosts
> (e.g. that dn't support virtio scsi).

(that e.g. don't support virtio-scsi)

> Allow a separate legacy feature table for such cases.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio.h  |  4 ++++
>  drivers/virtio/virtio.c | 25 ++++++++++++++++++++++++-
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 

> @@ -177,7 +185,22 @@ static int virtio_dev_probe(struct device *_d)
>  		driver_features |= (1ULL << f);
>  	}
> 
> -	dev->features = driver_features & device_features;
> +	/* Some drivers have a separate feature tables for virtio v1.0 */

/* some drivers have a separate feature table for legacy virtio */

?

> +	if (drv->feature_table_legacy) {
> +		driver_features_legacy = 0;
> +		for (i = 0; i < drv->feature_table_size_legacy; i++) {
> +			unsigned int f = drv->feature_table_legacy[i];
> +			BUG_ON(f >= 64);
> +			driver_features_legacy |= (1ULL << f);
> +		}
> +	} else {
> +		driver_features_legacy = driver_features;
> +	}
(...)

