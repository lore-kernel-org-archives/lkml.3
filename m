Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaAFEZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 23:25:43 -0500
Received: from mail.active-venture.com ([67.228.131.205]:63779 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaAFEZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 23:25:41 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52CA3045.80807@roeck-us.net>
Date: Sun, 05 Jan 2014 20:25:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] isdn: Mark build for telespci and hfc_pci as broken
 for big endian ARM
References: <1388951367-7411-1-git-send-email-linux@roeck-us.net> <20140105.203959.962622308205839285.davem@davemloft.net>
In-Reply-To: <20140105.203959.962622308205839285.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2014 05:39 PM, David Miller wrote:
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Sun,  5 Jan 2014 11:49:27 -0800
>
>> With arm:allmodconfig, building the Teles PCI driver fails with
>>
>> telespci.c:294:2: error: #error "not running on big endian machines now"
>>
>> Similar, building the driver for HFC PCI-Bus cards fails with
>>
>> hfc_pci.c:1647:2: error: #error "not running on big endian machines now"
>>
>> Mark build as broken for big endian ARM machines.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>
> Let's not start getting into the habit of doing this, please.
>
> The reason this isn't easy to do generically from Kconfig is
> probably because it almost never makes any sense to do so.
>
> In fact, if you look at telespci.c there are no DMA descriptors,
> everything is read using MMIO acccesses via the chips FIFO.  There
> really can't be any endianness problems that I see.
>
> Please just remove the CPP checks, that's the best fix.
>

Both drivers build with arm:allmodconfig if I remove the check,
so I am fine with that. I'll send an updated patch.

Thanks,
Guenter


