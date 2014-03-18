Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbaCRXIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:08:35 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:42651 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaCRXId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:08:33 -0400
Message-ID: <5328D1EF.70709@gmail.com>
Date: Tue, 18 Mar 2014 17:08:31 -0600
From: Joel Pelaez Jorge <joelpelaez@gmail.com>
Organization: DarkSoft Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'Rashika Kheria'" <rashika.kheria@gmail.com>,
        "'Peter P Waskiewicz Jr'" <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: slicoss: Fix prefer ether_addr_copy over memcpy
References: <5327D3C6.70400@gmail.com> <000101cf426d$cba30240$62e906c0$%han@samsung.com>
In-Reply-To: <000101cf426d$cba30240$62e906c0$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 17/03/14 23:49, Jingoo Han escribió:
> On Tuesday, March 18, 2014 2:04 PM, Joel Pelaez Jorge wrote:
>>
>>
>> @@ -810,8 +810,8 @@ static int slic_mac_set_address(struct net_device
>> *dev, void *ptr)
>>    	if (!is_valid_ether_addr(addr->sa_data))
>>    		return -EINVAL;
>>
>> -	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
>> -	memcpy(adapter->currmacaddr, addr->sa_data, dev->addr_len);
>> +	ether_addr_copy(dev->dev_addr, addr->sa_data);
>> +	ether_addr_copy(adapter->currmacaddr, addr->sa_data);
>
> By the way, I am wondering if 'dev->addr_len' is 6 bytes.
> Is there anyone who can confirm it?
>
> If nobody can confirm 'dev->addr_len' is 6 bytes, it should
> not be changed to 'ether_addr_copy()'.
>
> Best regards,
> Jingoo Han
>
In the first case, is necessary use memcpy for copy te ethernet address 
to dev->dev_addr because this is a pointer, uses dev->addr_len for 
define size.

But in the second, adapter->currmacaddr is fixed to 6 size, so that here 
one can use ether_addr_copy without issues.

--
Best regards,
Joel Pelaez Jorge
Joel Pelaez Jorge


