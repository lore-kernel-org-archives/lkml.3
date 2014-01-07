Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaAGNyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:54:52 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:9398 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaAGNyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:54:46 -0500
X-AuditID: cbfec373-b7f4a6d000005e0a-bb-52cc0724332d
Date: Tue, 07 Jan 2014 11:54:38 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 13/19] media: dvb_core: slight optimization of addr
 compare
Message-id: <20140107115438.02c7424e@samsung.com>
In-reply-to: <52BC0E56.80003@huawei.com>
References: <52BA5113.7070908@huawei.com> <52BABA23.2040709@cogentembedded.com>
 <52BC0E56.80003@huawei.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t/hYF0V9jNBBieOili8ObqDzeLyrjls
	Fj0btrJaHFsgZnFm1S12B1aPB1P/M3m0HHnL6vF5k1wAcxSXTUpqTmZZapG+XQJXxuvDCQX7
	xCr6rig0MC7l72Lk5JAQMJFYfqqDFcIWk7hwbz1bFyMXh5DAEkaJC1+3sIMkhAR6mCT6/ouC
	2CwCqhIH9nxiArHZBIwkXjW2gDWLCGhLvLsyjQWkmVlgN6PE7UPtYEXCAiESr398ZQSxeQUM
	JWYffgM2lFNAQ6J9+SWgGg6gBbkSx78Jg5gSAk4Suw9IQVQLSvyYfI8FxGYW0JLYvK2JFcKW
	l9i85i3zBEaBWUjKZiEpm4WkbAEj8ypG0dLi5ILipPRcI73ixNzi0rx0veT83E2MkKAt3sH4
	YoPVIUYBDkYlHt6Ju08FCbEmlhVX5h5ilOBgVhLhZb5xOkiINyWxsiq1KD++qDQntfgQIxMH
	p1QDo+sCnjOsEzqWvUm3fmy4zsXutOmMqkjR/WWS8eriVa92RZapXMqeLHvu9x8eS1GJgqAj
	wh5ejvblB22kNu6tkN02q2ky+yp+mauV2u2u7Asezo+cz7vSNGb2xYSwxVJubRGXZO5afXwc
	dnaP0Zys+G2GaRd2xtmz5zUov4wWdrCqkF3owrlNiaU4I9FQi7moOBEAfk/d/zgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 26 Dec 2013 19:09:10 +0800
Ding Tianhong <dingtianhong@huawei.com> escreveu:

> On 2013/12/25 18:57, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 25-12-2013 7:29, Ding Tianhong wrote:
> > 
> >> Use possibly more efficient ether_addr_equal
> >> instead of memcmp.
> > 
> >> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >> Cc: linux-media@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> >> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> >> ---
> >>   drivers/media/dvb-core/dvb_net.c | 8 ++++----
> >>   1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> >> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> >> index f91c80c..3dfc33b 100644
> >> --- a/drivers/media/dvb-core/dvb_net.c
> >> +++ b/drivers/media/dvb-core/dvb_net.c
> >> @@ -179,7 +179,7 @@ static __be16 dvb_net_eth_type_trans(struct sk_buff *skb,
> >>       eth = eth_hdr(skb);
> >>
> >>       if (*eth->h_dest & 1) {
> >> -        if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)==0)
> >> +        if(ether_addr_equal(eth->h_dest,dev->broadcast))
> > 
> >    There should be space after comma.
> > 
> >> @@ -674,11 +674,11 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> >>                       if (priv->rx_mode != RX_MODE_PROMISC) {
> >>                           if (priv->ule_skb->data[0] & 0x01) {
> >>                               /* multicast or broadcast */
> >> -                            if (memcmp(priv->ule_skb->data, bc_addr, ETH_ALEN)) {
> >> +                            if (!ether_addr_equal(priv->ule_skb->data, bc_addr)) {
> >>                                   /* multicast */
> >>                                   if (priv->rx_mode == RX_MODE_MULTI) {
> >>                                       int i;
> >> -                                    for(i = 0; i < priv->multi_num && memcmp(priv->ule_skb->data, priv->multi_macs[i], ETH_ALEN); i++)
> >> +                                    for(i = 0; i < priv->multi_num && !ether_addr_equal(priv->ule_skb->data, priv->multi_macs[i]); i++)
> > 
> >    Shouldn't this line be broken?
> > 
> 
> ok, thanks.

Also, since you're touching on those lines, could you please add an space
after 'if' (on the first hunk) and after 'for' (on the second one)?

> 
> Regards
> >>                                           ;
> >>                                       if (i == priv->multi_num)
> >>                                           drop = 1;
> > 
> > WBR, Sergei
> > 
> > 
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Mauro
