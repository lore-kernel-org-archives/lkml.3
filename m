Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaJWHwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:52:16 -0400
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:53519 "EHLO
	forward-corp1m.yandex.ru" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752057AbaJWHwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:52:14 -0400
From: Roman Gushchin <klamm@yandex-team.ru>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
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
In-Reply-To: <1414002630.2179.0.camel@jtkirshe-mobl>
References: <1413985819-9553-1-git-send-email-klamm@yandex-team.ru> <1414002630.2179.0.camel@jtkirshe-mobl>
Subject: Re: [PATCH] igb: don't reuse pages with pfmemalloc flag
MIME-Version: 1.0
Message-Id: <4321414050723@webcorp02h.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 23 Oct 2014 11:52:03 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you!

Probably we should add it to stable trees too?

--
Regards,
Roman

22.10.2014, 22:30, "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>:
> On Wed, 2014-10-22 at 17:50 +0400, Roman Gushchin wrote:
>> šIncoming packet is dropped silently by sk_filter(), if the skb was
>> šallocated from pfmemalloc reserves and the corresponding socket is
>> šnot marked with the SOCK_MEMALLOC flag.
>>
>> šIgb driver allocates pages for DMA with __skb_alloc_page(), which
>> šcalls alloc_pages_node() with the __GFP_MEMALLOC flag. So, in case
>> šof OOM condition, igb can get pages with pfmemalloc flag set.
>>
>> šIf an incoming packet hits the pfmemalloc page and is large enough
>> š(small packets are copying into the memory, allocated with
>> šnetdev_alloc_skb_ip_align(), so they are not affected), it will be
>> šdropped.
>>
>> šThis behavior is ok under high memory pressure, but the problem is
>> šthat the igb driver reuses these mapped pages. So, packets are still
>> šdropping even if all memory issues are gone and there is a plenty
>> šof free memory.
>>
>> šIn my case, some TCP sessions hang on a small percentage (< 0.1%)
>> šof machines days after OOMs.
>>
>> šFix this by avoiding reuse of such pages.
>>
>> šSigned-off-by: Roman Gushchin <klamm@yandex-team.ru>
>> š---
>> ššdrivers/net/ethernet/intel/igb/igb_main.c | 6 +++++-
>> šš1 file changed, 5 insertions(+), 1 deletion(-)
>
> Thanks Roman, I have added you patch to my queue.
