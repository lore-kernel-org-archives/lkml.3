Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaAGDlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:41:46 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:62240 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202AbaAGDlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:41:44 -0500
Message-ID: <52CB7736.701@huawei.com>
Date: Tue, 7 Jan 2014 11:40:38 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3.5 10/19] mac8011: slight optimization of addr compare
References: <52BC15C8.2080400@huawei.com> <1389021111.5891.21.camel@jlt4.sipsolutions.net>
In-Reply-To: <1389021111.5891.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/6 23:11, Johannes Berg wrote:
> On Thu, 2013-12-26 at 19:40 +0800, Ding Tianhong wrote:
>> Use the possibly more efficient ether_addr_equal
>> to instead of memcmp.
> 
> This is a slow-path, I don't think that's really worth it. It kinda
> makes sense, but relies on the struct mac_address allocation for
> alignment and the fact that there are no other members in that struct,
> so it seems to me that this ought to also add some alignment attributes?
> 
> johannes
> 
> 

Yes, I had to say that it is really a slight optimization.And I am sure the address in the struct
is alignment, otherwise I have to use the ether_addr_equal_unaligned().

Regards
Ding 

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


