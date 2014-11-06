Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaKFI3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:29:13 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:59335 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaKFI3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:29:10 -0500
Message-ID: <545B3148.8000704@lab.ntt.co.jp>
Date: Thu, 06 Nov 2014 17:28:56 +0900
From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?EUC-KR?B?udq89sf2?= <suhyun.park@ahnlab.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
CC: "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bridge: missing null bridge device check causing null
 pointer dereference (bugfix)
References: <1415255192-13584-1-git-send-email-suhyun.park@ahnlab.com> <545B1E27.3080302@lab.ntt.co.jp> <8D1F1238A24CE743B8F3CED0F137C69E408AA087@EXMB02.ahnbang.ahnlab.com>
In-Reply-To: <8D1F1238A24CE743B8F3CED0F137C69E408AA087@EXMB02.ahnbang.ahnlab.com>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/06 16:58, 박수현 wrote:
>> -----Original Message-----
>> From: Toshiaki Makita [mailto:makita.toshiaki@lab.ntt.co.jp]
>> Sent: Thursday, November 06, 2014 4:07 PM
>> To: 박수현; Stephen Hemminger; David S. Miller
>> Cc: bridge@lists.linux-foundation.org; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] bridge: missing null bridge device check causing null
>> pointer dereference (bugfix)
>>
>> On 2014/11/06 15:26, Su-Hyun Park wrote:
>>> the bridge device can be null if the bridge is being deleted while
>>> processing the packet, which causes the null pointer dereference in
>> switch statement.
>>
>> How can this happen??
>> It is guarded by rcu.
>> netdev_rx_handler_unregister() ensures rx_handler_data is non NULL.
>>
> 
> The RCU protect rx_handler_data, not the bridge member port. It can be NULL according to below code.
> 
> static inline struct net_bridge_port *br_port_get_rcu(const struct net_device *dev) {
> 	struct net_bridge_port *port = rcu_dereference(dev->rx_handler_data);
> 	return br_port_exists(dev) ? port : NULL; 
> }

Seems to have been fixed for a year.
716ec052d228 ("bridge: fix NULL pointer deref of br_port_get_rcu")

Thanks,
Toshiaki Makita

