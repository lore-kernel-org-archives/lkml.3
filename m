Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbaJKBH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 21:07:27 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55053 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaJKBH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 21:07:26 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9B176Am007269, This message is accepted by code: ctloc85258
Message-ID: <543882B5.7090300@realsil.com.cn>
Date: Sat, 11 Oct 2014 09:07:01 +0800
From: Micky Ching <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v2] mfd: rtsx: fix PM suspend for 5227 & 5249
References: <1412920724-27945-1-git-send-email-micky_ching@realsil.com.cn> <20141010102104.GK26795@lee--X1>
In-Reply-To: <20141010102104.GK26795@lee--X1>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/10/2014 06:21 PM, Lee Jones wrote:
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
>>   6 files changed, 79 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/mfd/rtsx_gops.c
> [...]
>
>> +static inline int rtsx_pci_update_cfg_byte(struct rtsx_pcr *pcr, int addr,
>> +		u8 mask, u8 append)
>> +{
>> +	int err;
>> +	u8 val;
>> +
>> +	err = pci_read_config_byte(pcr->pci, addr, &val);
>> +	if (err < 0)
>> +		return err;
>> +	return pci_write_config_byte(pcr->pci, addr, (val & mask) | append);
>> +}
>> +
> Why is this in here?  Why not put it in the generic ops file?
This function is a good interface, we will use it many times in the future.

generic ops file is only used to some operation can be used for 
different chip,
some special chip may replace generic ops by provide their own ops.
So generic ops file is just use to abstract the same code, not for good 
interface.

>

-- 
Best Regards,
micky.
--------------------
Realsil Microelectronics Inc. PCBU swlinux.
Tel:86-512-6258-8966 Ext: 5806

