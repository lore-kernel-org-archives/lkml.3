Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3LXN7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 08:59:10 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56221 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3LXN7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 08:59:08 -0500
Message-ID: <52B99072.5070809@gmail.com>
Date: Tue, 24 Dec 2013 21:47:30 +0800
From: Ding Tianhong <dthxman@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Ding Tianhong <dingtianhong@huawei.com>
CC: Don Fry <pcnet32@frontier.com>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 03/20] net: pcnet: slight optimization of addr compare
References: <52B96FA7.10201@huawei.com> <1387888739.2259.7.camel@joe-AO722>
In-Reply-To: <1387888739.2259.7.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/12/24 20:38, Joe Perches 写道:
> On Tue, 2013-12-24 at 19:27 +0800, Ding Tianhong wrote:
>> Use possibly more efficient ether_addr_equal_unaligned
>> to instead of memcmp.
> 
> Hi again Ding.
> 
>> diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
> []
>> @@ -1668,7 +1668,7 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
> []
>> -	if (memcmp(promaddr, dev->dev_addr, ETH_ALEN) ||
>> +	if (!ether_addr_equal(promaddr, dev->dev_addr) ||
> 
> Can you please make sure the commit message matches the
> code changes?
> 
> This uses ether_addr_equal not ether_addr_equal_unaligned.
> 
> Thanks for the work.
> 

Oh， no,  maybe I was dizzy by these patches,  I should be more careful,
sorry about that, I will resend this one.

Regards
Ding

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

