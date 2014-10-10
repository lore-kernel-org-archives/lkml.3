Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaJJJ3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:29:22 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46745 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaJJJ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:29:20 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9A9T3TZ013803, This message is accepted by code: ctloc85258
Message-ID: <5437A6E0.9020408@realsil.com.cn>
Date: Fri, 10 Oct 2014 17:29:04 +0800
From: Micky Ching <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v2] mfd: rtsx: fix PM suspend for 5227 & 5249
References: <1412920724-27945-1-git-send-email-micky_ching@realsil.com.cn> <20141010092440.GF26795@lee--X1>
In-Reply-To: <20141010092440.GF26795@lee--X1>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/10/2014 05:24 PM, Lee Jones wrote:
> On Fri, 10 Oct 2014, micky_ching@realsil.com.cn wrote:
>
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> Fix rts5227&5249 failed send buffer cmd after suspend,
>> PM_CTRL3 should reset before send any buffer cmd after suspend.
>> Otherwise, buffer cmd will failed, this will lead resume fail.
>>
>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>> ---
>>   drivers/mfd/Makefile         |  2 +-
>>   drivers/mfd/rts5227.c        |  6 ++++++
>>   drivers/mfd/rts5249.c        |  4 ++++
>>   drivers/mfd/rtsx_gops.c      | 37 +++++++++++++++++++++++++++++++++++++
>>   drivers/mfd/rtsx_pcr.h       |  3 +++
>>   include/linux/mfd/rtsx_pci.h | 28 ++++++++++++++++++++++++++++
> These are Card Reader drivers right?
>
> Do you know why these are in MFD?
Hi Lee,

Our chips support SD/MMC card and MS card,
SD/MMC card driver is put into mmc/ subsystem,
MS card driver is put into memstick/ subsystem.
We put the common functions into mfd/ subsystem.

>
>>   6 files changed, 79 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/mfd/rtsx_gops.c
>

-- 
Best Regards,
micky.
--------------------
Realsil Microelectronics Inc. PCBU swlinux.
Tel:86-512-6258-8966 Ext: 5806

