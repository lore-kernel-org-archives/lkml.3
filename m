Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab3LKGXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:23:15 -0500
Received: from asix.com.tw ([113.196.140.82]:11302 "EHLO freebsd1.asix.com.tw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750902Ab3LKGXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:23:13 -0500
Message-ID: <52A80397.2080508@asix.com.tw>
Date: Wed, 11 Dec 2013 14:17:59 +0800
From: Freddy Xin <freddy@asix.com.tw>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, louis@asix.com.tw, allan@asix.com.tw
Subject: Re: [PATCH 1/1] AX88179_178A: Enable the hardware pseudo header in
 case of the NET_IP_ALIGN equals 0
References: <1386323898-2246-1-git-send-email-freddy@asix.com.tw> <20131209.200131.1376169274733452706.davem@davemloft.net>
In-Reply-To: <20131209.200131.1376169274733452706.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013年12月10日 09:01, David Miller wrote:
> From: freddy@asix.com.tw
> Date: Fri,  6 Dec 2013 17:58:18 +0800
>
>> From: Freddy Xin <freddy@asix.com.tw>
>>
>> The AX88179_178A has a hardware feature that it can insert a 2-bytes pseudo
>> header in front of each received frame by setting the AX_RX_CTL_IPE bit.
>> This feature is used to let the IP header be aligned on a doubleword-aligned address,
>> but the NET_IP_ALIGN may equals to 2 and the __netdev_alloc_skb_ip_align in USBNET will
>> reserve 2 bytes also, so in this case the driver shouldn't enable this bit.
>>
>> This patch modifies the driver to set AX_RX_CTL_IPE just in case of the NET_IP_ALIGN equals 0.
>>
>> Signed-off-by: Freddy Xin <freddy@asix.com.tw>
> Please avoid larger than 80 column lines in your commit messages,
> people use text-only tools to viee these.
>
> Next, it makes no sense to restrict your change to NET_IP_ALIGN==0
>
> Simply handle any case, by undoing the reservation if it's getting
> in the way.  If there isn't an appropriate helper for this, add one.
>
I think there is no way of undoing the reservation in the driver.
Can I add a flag of the driver_info, and use it to determine
whether undoing the reservation in rx_submit of usbnet?
