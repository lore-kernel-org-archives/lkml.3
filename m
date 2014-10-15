Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaJOEkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 00:40:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaJOEku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 00:40:50 -0400
Message-ID: <543DFACB.5030905@redhat.com>
Date: Wed, 15 Oct 2014 12:40:43 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC] virtio_net: enable tx interrupt
References: <1413323524-23380-1-git-send-email-mst@redhat.com>	<20141014231154.GA23806@redhat.com> <543DF92C.6060209@redhat.com>
In-Reply-To: <543DF92C.6060209@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 12:33 PM, Jason Wang wrote:
> On 10/15/2014 07:11 AM, Michael S. Tsirkin wrote:
>> > On Wed, Oct 15, 2014 at 12:53:59AM +0300, Michael S. Tsirkin wrote:
>>>> >> >  static void skb_xmit_done(struct virtqueue *vq)
>>>> >> >  {
>>>> >> >  	struct virtnet_info *vi = vq->vdev->priv;
>>>> >> > +	struct send_queue *sq = &vi->sq[vq2txq(vq)];
>>>> >> >  
>>>> >> > -	/* Suppress further interrupts. */
>>>> >> > -	virtqueue_disable_cb(vq);
>>>> >> > -
>> > One note here: current code seems racy because of doing
>> > virtqueue_disable_cb from skb_xmit_done that I'm dropping here: there's
>> > no guarantee we don't get an interrupt while tx ring is running, and if
>> > that happens we can end up with interrupts disabled forever.
>> >
> Looks harmless since:
>
> - if event index is enabled, virtqueue_disable_cb() does nothing in fact.
> - if event index is disabled, we don't depend on tx interrupt and when
> num_free is low we will try to enable the tx interrupt again.

Ok, I think I get you here. For 'current' you mean the rfc I post.
