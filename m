Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3L1PN5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 10:13:57 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38743 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3L1PN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 10:13:56 -0500
Message-ID: <52BEE7F0.1070506@gmail.com>
Date: Sat, 28 Dec 2013 23:02:08 +0800
From: Ding Tianhong <dthxman@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Ding Tianhong <dingtianhong@huawei.com>,
        =?UTF-8?B?U2p1ciBCcsOmbmRlbGFuZA==?= 
	<sjur.brandeland@stericsson.com>
CC: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 20/20] net: caif: slight optimization of addr
 compare
References: <52BE6D50.9000308@huawei.com> <1388213953.24123.2.camel@joe-AO722>
In-Reply-To: <1388213953.24123.2.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/12/28 14:59, Joe Perches 写道:
> On Sat, 2013-12-28 at 14:18 +0800, Ding Tianhong wrote:
>> Use possibly more efficient ether_addr_equal
>> to instead of memcmp.
> 
> This may be a distinction without difference, but
> is a CAIF seghead also an ethernet address?
> 

NO，this is a coincidence, the CAIF seghead is 6 bytes too,
So from a logical point of view, maybe a new function with
suitable name will be more reasonable here, but the name of
ether_addr_equal is not correctly here.:)

thanks

Regards
Ding

>> diff --git a/net/caif/cfrfml.c b/net/caif/cfrfml.c
> []
>> @@ -79,7 +79,7 @@ static struct cfpkt *rfm_append(struct cfrfml *rfml, char *seghead,
> []
>>  	/* Verify correct header */
>> -	if (memcmp(seghead, rfml->seghead, 6) != 0)
>> +	if (!ether_addr_equal(seghead, rfml->seghead))
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

