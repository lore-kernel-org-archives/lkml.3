Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbaKTJxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:53:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180AbaKTJxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:53:12 -0500
Message-ID: <546DB9F2.2020806@redhat.com>
Date: Thu, 20 Nov 2014 17:52:50 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH net V5] virtio-net: validate features during probe
References: <1416474185-10981-1-git-send-email-jasowang@redhat.com> <20141120104824.0a9e2060.cornelia.huck@de.ibm.com>
In-Reply-To: <20141120104824.0a9e2060.cornelia.huck@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 05:48 PM, Cornelia Huck wrote:
> On Thu, 20 Nov 2014 17:03:05 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> We currently trigger BUG when VIRTIO_NET_F_CTRL_VQ
>> is not set but one of features depending on it is.
>> That's not a friendly way to report errors to
>> hypervisors.
>> Let's check, and fail probe instead.
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
>> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> +static bool virtnet_validate_features(struct virtio_device *vdev)
>> +{
>> +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ) &&
>> +	    (VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_RX,
>> +			     "VIRTIO_NET_F_CTRL_VQ") ||
>> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_VLAN,
>> +			     "VIRTIO_NET_F_CTRL_VQ") ||
>> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_GUEST_ANNOUNCE,
>> +			     "VIRTIO_NET_F_CTRL_VQ") ||
>> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
>> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
>> +			     "VIRTIO_NET_F_CTRL_VQ"))) {
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
> I still think it may make sense to print all incorrectly set bits, but
> let's just fix the BUG() trigger for now.
>
> Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>

Right, will do it in the future.

Thanks

