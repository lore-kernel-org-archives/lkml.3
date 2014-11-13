Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaKMJuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:50:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbaKMJt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:49:58 -0500
Message-ID: <54647EB6.5030507@redhat.com>
Date: Thu, 13 Nov 2014 17:49:42 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] virito: introduce methods of fixing device features
References: <1415857974-23326-1-git-send-email-jasowang@redhat.com>	<20141113094604.1f248c3d.cornelia.huck@de.ibm.com>	<546475C2.50606@redhat.com> <20141113101456.43acfdb7.cornelia.huck@de.ibm.com>
In-Reply-To: <20141113101456.43acfdb7.cornelia.huck@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 05:14 PM, Cornelia Huck wrote:
> On Thu, 13 Nov 2014 17:11:30 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 11/13/2014 04:46 PM, Cornelia Huck wrote:
>>> On Thu, 13 Nov 2014 13:52:53 +0800
>>> Jason Wang <jasowang@redhat.com> wrote:
>>>> +static inline void virtio_disable_feature(struct virtio_device *vdev,
>>>> +                                          unsigned int fbit)
>>>> +{
>>>> +	BUG_ON(fbit >= VIRTIO_TRANSPORT_F_START);
>>>> +	BUG_ON(vdev->config->get_status(vdev) &
>>>> +	       ~(VIRTIO_CONFIG_S_ACKNOWLEDGE | VIRTIO_CONFIG_S_DRIVER));
>>> When we add virtio-1 support, we can add a check for FEATURES_OK here,
>>> so we're really on the safe side.
>>>
>> If I read the spec correctly, FEATURES_OK was set only after writing the
>> features bits to device. But we want to sanitize the them before.
> I meant doing a BUG when FEATURES_OK is set - sorry for not being clear.
>

I get it, thanks for the clarification.
