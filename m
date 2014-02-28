Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaB1FmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:42:16 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36038 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaB1FmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:42:14 -0500
MIME-Version: 1.0
In-Reply-To: <53101E1A.6020707@huawei.com>
References: <530FF7BF.4030706@huawei.com> <53100677.2060705@intel.com> <53101E1A.6020707@huawei.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 27 Feb 2014 21:41:33 -0800
Message-ID: <CAGVrzcb_eD18-XGC34fZaQFbH3f5-NZk+6N5YbjYMSxCCSZX2w@mail.gmail.com>
Subject: Re: [PATCH net RESEND] vlan: don't allow to add VLAN on VLAN device
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: John Fastabend <john.r.fastabend@intel.com>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-27 21:26 GMT-08:00 Ding Tianhong <dingtianhong@huawei.com>:
> On 2014/2/28 11:45, John Fastabend wrote:
>> On 2/27/2014 6:43 PM, Ding Tianhong wrote:
>>> I run these steps:
>>>
>>> modprobe 8021q
>>> vconfig add eth2 20
>>> vconfig add eth2.20 20
>>> ifconfig eth2 xx.xx.xx.xx
>>>
>>> then the Call Trace happened:
>>>
>>
>> [...]
>>
>>> ========================================================================
>>>
>>> The reason is that if add vlan on vlan dev, the vlan dev will create vlan_info,
>>> then the notification will let the real dev to run dev_set_rx_mode() and hold
>>> netif_addr_lock, and then the real dev will call ndo_set_rx_mode(), if the real
>>> dev is vlan dev, the ndo_set_rx_mode() will hold netif_addr_lock again, so deadlock
>>> happened.
>>>
>>> Don't allow to add vlan on vlan dev to fix this problem.
>>>
>>> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>>> ---
>>
>> I'm not sure we can just disable stacked vlans. There might be something
>> using them today and they have worked in the past. Lets try to find a
>> better fix.
>>
>> .John
>
> Yes, maybe I miss something, can you gave me a scene that the use of eth2.20.30?
> the device is created from vlan device eth2.20, than I will find a better way to fix it.

Is not QinQ (802.1ad) such as case [1]?

[1]: http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8ad227ff89a7e6f05d07cd0acfd95ed3a24450ca
--
Florian
