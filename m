Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaJWLVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:21:21 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:35268 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351AbaJWLVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:21:19 -0400
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
In-Reply-To: <1413992737.9031.1.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1413985819-9553-1-git-send-email-klamm@yandex-team.ru> <1413992737.9031.1.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] igb: don't reuse pages with pfmemalloc flag
MIME-Version: 1.0
Message-Id: <1811414063272@webcorp02e.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 23 Oct 2014 15:21:12 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Interesting...
>
> It seems we also need to clear skb->pfmemalloc in napi_reuse_skb()

Sounds reasonable, but are you sure, that we can just drop skb->pfmemalloc flag in napi_reuse_skb()?

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/
