Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab3GIDRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 23:17:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab3GIDRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 23:17:21 -0400
Message-ID: <51DB80B1.60009@redhat.com>
Date: Tue, 09 Jul 2013 11:17:05 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] virtio_net: fix race in RX VQ processing
References: <1373274069-4301-1-git-send-email-mst@redhat.com>
In-Reply-To: <1373274069-4301-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 05:05 PM, Michael S. Tsirkin wrote:
> Jason Wang reported a race in RX VQ processing:
> virtqueue_enable_cb is called outside napi lock,
> violating virtio serialization rules.
> The race has been there from day 1, but it got especially nasty in 3.0
> when commit a5c262c5fd83ece01bd649fb08416c501d4c59d7
> "virtio_ring: support event idx feature"
> added more dependency on vq state.
>
> Please review, and consider for 3.11 and for stable.
>
> Jason, could you please report whether this fixes the issues for you?

Yes, I confirm this fixes the issue.

Since I can only reproduce it by adding udelay in virtqueue_enable_cb()
after virtio_mb(). I validate this also with this.

Thanks
