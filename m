Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaAGIho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:37:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:10234 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbaAGIhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:37:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="434989398"
Message-ID: <52CBBCCB.6030000@intel.com>
Date: Tue, 07 Jan 2014 00:37:31 -0800
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Neil Horman <nhorman@tuxdriver.com>,
        e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH net 2/2] net: core: explicitly select a txq before doing
 l2 forwarding
References: <1388978467-2075-1-git-send-email-jasowang@redhat.com> <1388978467-2075-2-git-send-email-jasowang@redhat.com> <52CBB94D.6010405@intel.com>
In-Reply-To: <52CBB94D.6010405@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

>>
>> +int dfwd_direct_xmit(struct sk_buff *skb, struct net_device *dev,
>> +             void *accel_priv)
>> +{
>> +    struct netdev_queue *txq;
>> +    int ret = NETDEV_TX_BUSY;
>> +    int index;
>> +
>> +    BUG_ON(!dev->netdev_ops->ndo_dfwd_select_queue);
>> +    index =    dev->netdev_ops->ndo_dfwd_select_queue(dev, skb,
>> +                               accel_priv);
>> +
>> +    local_bh_disable();
>> +
>> +    skb_set_queue_mapping(skb, index);
>
> How about replacing the index calculation and skb_set_queue_mapping with
> netdev_pick_tx(). Then we don't need to add a new op and the existing
> XPS, tx hash and select_queue() op works.
>

Sorry for the noise that was dumb it wouldn't work.

