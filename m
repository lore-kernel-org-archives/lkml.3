Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbaFQTVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:21:16 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:52604 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933639AbaFQTVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140616.214247.1154200670003936158.davem@davemloft.net>
References: <1402964326-11147-1-git-send-email-isubramanian@apm.com>
	<1402964326-11147-5-git-send-email-isubramanian@apm.com>
	<20140616.214247.1154200670003936158.davem@davemloft.net>
Date: Tue, 17 Jun 2014 12:21:08 -0700
Message-ID: <CAKh23F=2undAW=nWibOreAM8DJiQKpLx=OboCX=fNZE+OU=AbA@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] drivers: net: Add APM X-Gene SoC ethernet driver support.
From: Iyappan Subramanian <isubramanian@apm.com>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "jcm@redhat.com" <jcm@redhat.com>, patches <patches@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 9:42 PM, David Miller <davem@davemloft.net> wrote:
> From: Iyappan Subramanian <isubramanian@apm.com>
> Date: Mon, 16 Jun 2014 17:18:46 -0700
>
>> +static netdev_tx_t xgene_enet_start_xmit(struct sk_buff *skb,
>> +                                      struct net_device *ndev)
>> +{
>> +     struct xgene_enet_pdata *pdata = netdev_priv(ndev);
>> +     struct xgene_enet_desc_ring *tx_ring = pdata->tx_ring;
>> +     struct xgene_enet_desc_ring *cp_ring = tx_ring->cp_ring;
>> +     u32 tx_level, cq_level;
>> +
>> +     tx_level = xgene_enet_ring_len(tx_ring);
>> +     cq_level = xgene_enet_ring_len(cp_ring);
>> +     if (unlikely(tx_level > pdata->tx_qcnt_hi ||
>> +                  cq_level > pdata->cp_qcnt_hi)) {
>> +             netif_stop_queue(ndev);
>> +             return NETDEV_TX_BUSY;
>> +     }
>> +
>> +     if (xgene_enet_setup_tx_desc(tx_ring, skb))
>> +             return NETDEV_TX_OK;
>
> If you return NETDEV_TX_OK, it is your responsibility to deal with the
> SKB, because you own it.
>
> In particular, you have to free the packet.

skb freeing happens in xgene_enet_tx_completion().
