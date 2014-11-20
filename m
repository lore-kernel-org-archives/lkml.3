Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbaKTJsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:48:39 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:33897 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbaKTJsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:48:36 -0500
Date: Thu, 20 Nov 2014 10:48:24 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH net V5] virtio-net: validate features during probe
Message-ID: <20141120104824.0a9e2060.cornelia.huck@de.ibm.com>
In-Reply-To: <1416474185-10981-1-git-send-email-jasowang@redhat.com>
References: <1416474185-10981-1-git-send-email-jasowang@redhat.com>
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
x-cbid: 14112009-0041-0000-0000-00000230603C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014 17:03:05 +0800
Jason Wang <jasowang@redhat.com> wrote:

> We currently trigger BUG when VIRTIO_NET_F_CTRL_VQ
> is not set but one of features depending on it is.
> That's not a friendly way to report errors to
> hypervisors.
> Let's check, and fail probe instead.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

> +static bool virtnet_validate_features(struct virtio_device *vdev)
> +{
> +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ) &&
> +	    (VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_RX,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_VLAN,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_GUEST_ANNOUNCE,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
> +			     "VIRTIO_NET_F_CTRL_VQ"))) {
> +		return false;
> +	}
> +
> +	return true;
> +}

I still think it may make sense to print all incorrectly set bits, but
let's just fix the BUG() trigger for now.

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

