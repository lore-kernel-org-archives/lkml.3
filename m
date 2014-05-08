Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaEHUpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:45:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59010 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbaEHUpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:45:00 -0400
Date: Thu, 08 May 2014 16:44:58 -0400 (EDT)
Message-Id: <20140508.164458.157597820665207475.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v2] Add support for netvsc build without
 CONFIG_SYSFS flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399581693-25050-1-git-send-email-haiyangz@microsoft.com>
References: <1399581693-25050-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 May 2014 13:45:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu,  8 May 2014 13:41:33 -0700

> +static inline void netvsc_record_rx_queue(struct sk_buff *skb,
> +					  struct hv_netvsc_packet *packet,
> +					  struct net_device *ndev)
> +{
> +#ifdef CONFIG_SYSFS
> +	skb_record_rx_queue(skb, packet->channel->
> +			    offermsg.offer.sub_channel_index %
> +			    ndev->real_num_rx_queues);
> +#endif
> +}

This is still fantastically gross, what is so unique about your
driver that it needs hacks like this?  No other driver to my
knowledge does.

Figure out what it is that makes your driver so unique, and
try to make it conform to how other drivers handle these
features without SYSFS ifdef'ery instead.

I'm not applying this patch, sorry.

Thanks.
