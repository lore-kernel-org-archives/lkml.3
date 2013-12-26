Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3LZIk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 03:40:29 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:65136 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3LZIk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 03:40:28 -0500
Message-ID: <52BBEA6A.40000@huawei.com>
Date: Thu, 26 Dec 2013 16:35:54 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Rupesh Gujare <rupesh.gujare@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 08/19] ozwpan: slight optimization of addr compare
References: <52BA50E9.1080203@huawei.com> <52BAB983.3090201@cogentembedded.com>
In-Reply-To: <52BAB983.3090201@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/25 18:54, Sergei Shtylyov wrote:
> Hello.
> 
> On 25-12-2013 7:28, Ding Tianhong wrote:
> 
>> Use possibly more efficient ether_addr_equal
>> instead of memcmp.
> 
>> Cc: Rupesh Gujare <rupesh.gujare@atmel.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: devel@driverdev.osuosl.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Tan Xiaojun <tanxiaojun@huawei.com>
>> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>> ---
>>   drivers/staging/ozwpan/ozcdev.c  | 2 +-
>>   drivers/staging/ozwpan/ozproto.c | 5 +++--
>>   2 files changed, 4 insertions(+), 3 deletions(-)
> 
>> diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
>> index 6ce0af9..c363f66 100644
>> --- a/drivers/staging/ozwpan/ozcdev.c
>> +++ b/drivers/staging/ozwpan/ozcdev.c
>> @@ -448,7 +448,7 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
>>       }
>>       spin_lock(&g_cdev.lock);
>>       if ((g_cdev.active_pd == NULL) &&
>> -        (memcmp(pd->mac_addr, g_cdev.active_addr, ETH_ALEN) == 0)) {
>> +        (ether_addr_equal(pd->mac_addr, g_cdev.active_addr))) {
> 
>    There's no point in enclosing function call into parens.
> 
> WBR, Sergei
> 

ok, thanks.

Regards
Ding
> 
> 


