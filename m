Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaDPHKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:10:34 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:17428 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaDPHKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:10:32 -0400
Message-ID: <534E2C97.4040908@hp.com>
Date: Wed, 16 Apr 2014 15:09:11 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sathya.perla@emulex.com, subbu.seetharaman@emulex.com,
        ajit.khaparde@emulex.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/net: add missing rtnl lock/unlock for benet
References: <1397544352-28841-1-git-send-email-zhen-hual@hp.com> <20140415.150950.2105729446204659132.davem@davemloft.net> <534E2399.5030801@hp.com>
In-Reply-To: <534E2399.5030801@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
I have sent out another patch for the fix.

Thanks
ZhenHua
On 04/16/2014 02:30 PM, Li, ZhenHua wrote:
> Hi David,
>
> I think you are right. I checked other NIC drivers, found some of them
> call rtnl_lock and rtnl_unlock around netif_device_detach and attach
> functions, while some drivers did not.
>
> I will create a new patch in generic way to fix this.
>
> Regards
> ZhenHua
> On 04/16/2014 03:09 AM, David Miller wrote:
>> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
>> Date: Tue, 15 Apr 2014 14:45:52 +0800
>>
>>> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
>>>
>>> In benet driver, netif_device_detach and netif_device_attach should be
>>> called between rtnl_lock and rtnl_unlock.
>>>
>>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>>
>> This absolutely does not look like a driver specific issue, therefore
>> I do not want you to make such locking context adjustments only in
>> your driver.
>>
>> Do it somewhere generic so that every driver gets the fix, not just
>> your driver.
>>
>

