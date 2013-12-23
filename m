Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab3LWO0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:26:03 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36171 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3LWOZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:25:58 -0500
Message-ID: <52B8452F.4070508@gmail.com>
Date: Mon, 23 Dec 2013 22:14:07 +0800
From: Ding Tianhong <dthxman@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, Ding Tianhong <dingtianhong@huawei.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/21] wireless: slight optimization of addr compare
References: <52B7C600.8030907@huawei.com> <52B83EE1.4040705@openwrt.org>
In-Reply-To: <52B83EE1.4040705@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/12/23 21:47, Felix Fietkau 写道:
> On 2013-12-23 06:11, Ding Tianhong wrote:
>> Use the recently added and possibly more efficient
>> ether_addr_equal_unaligned to instead of memcmp.
> It looks to me like all of these (including the ones in the other
> similar patches) are in places, where the address data is aligned to at
> least 16 bit. Because of this, using ether_addr_equal instead of
> ether_addr_equal_unaligned would be much better for platforms without
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.
> 
> - Felix

Yes, the most of the place should use ether_addr_equal. thanks.

Regards
Ding

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

