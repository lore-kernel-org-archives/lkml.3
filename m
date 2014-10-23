Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbaJWN5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:57:15 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:38101 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbaJWN5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:57:11 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2014 09:57:10 EDT
From: Roman Gushchin <klamm@yandex-team.ru>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "bruce.w.allan@intel.com" <bruce.w.allan@intel.com>,
        "carolyn.wyborny@intel.com" <carolyn.wyborny@intel.com>,
        "donald.c.skidmore@intel.com" <donald.c.skidmore@intel.com>,
        "gregory.v.rose@intel.com" <gregory.v.rose@intel.com>,
        "peter.p.waskiewicz.jr@intel.com" <peter.p.waskiewicz.jr@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "john.ronciak@intel.com" <john.ronciak@intel.com>,
        "tushar.n.dave@intel.com" <tushar.n.dave@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sassmann@kpanic.de" <sassmann@kpanic.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1414071030.2094.46.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1413985819-9553-1-git-send-email-klamm@yandex-team.ru>
	 <1413992737.9031.1.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1811414063272@webcorp02e.yandex-team.ru> <1414071030.2094.46.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATHC] net: napi_reuse_skb() should check pfmemalloc
MIME-Version: 1.0
Message-Id: <1131414072170@webcorp02e.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 23 Oct 2014 17:49:30 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>

--
@klamm


23.10.2014, 17:30, "Eric Dumazet" <eric.dumazet@gmail.com>:
> From: Eric Dumazet <edumazet@google.com>
>
> Do not reuse skb if it was pfmemalloc tainted, otherwise
> future frame might be dropped anyway.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
> šnet/core/dev.c | ššš4 ++++
> š1 file changed, 4 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b793e3521a36..945bbd001359 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4157,6 +4157,10 @@ EXPORT_SYMBOL(napi_gro_receive);
>
> šstatic void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
> š{
> + if (unlikely(skb->pfmemalloc)) {
> + consume_skb(skb);
> + return;
> + }
> ššššššššš__skb_pull(skb, skb_headlen(skb));
> ššššššššš/* restore the reserve we had after netdev_alloc_skb_ip_align() */
> šššššššššskb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN - skb_headroom(skb));
