Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaKYRsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:48:23 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:54314 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaKYRsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:48:19 -0500
Date: Tue, 25 Nov 2014 18:48:11 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 09/42] virtio: set FEATURES_OK
Message-ID: <20141125184811.3191f8db.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-10-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-10-git-send-email-mst@redhat.com>
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
x-cbid: 14112517-0025-0000-0000-0000029388A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:42:01 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> set FEATURES_OK as per virtio 1.0 spec
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/uapi/linux/virtio_config.h |  2 ++
>  drivers/virtio/virtio.c            | 29 ++++++++++++++++++++++-------
>  2 files changed, 24 insertions(+), 7 deletions(-)
> 

> +	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> +		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
> +		status = dev->config->get_status(dev);
> +		if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> +			printk(KERN_ERR "virtio: device refuses features: %x\n",
> +			       status);

Can you use dev_err() to include the information which device failed?

> +			err = -ENODEV;
> +			goto err;
> +		}
> +	}

