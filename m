Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab3LRBP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:15:29 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:59657 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3LRBP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:15:28 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBI1F8Xi002407, This message is accepted by code: ctloc85258
Message-ID: <52B0F7A6.20601@realsil.com.cn>
Date: Wed, 18 Dec 2013 09:17:26 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <wei_wang@realsil.com.cn>,
        <rogerable@realtek.com>, <devel@linuxdriverproject.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v3 1/2] mfd: rtsx: reduce code duplication in rtl8411
References: <cover.1387246693.git.micky_ching@realsil.com.cn> <4dbd7d35c3e2201a77357155f6610abda69a3139.1387246693.git.micky_ching@realsil.com.cn> <20131217072842.GZ28413@mwanda>
In-Reply-To: <20131217072842.GZ28413@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 03:28 PM, Dan Carpenter wrote:
> On Tue, Dec 17, 2013 at 10:36:58AM +0800, micky_ching@realsil.com.cn wrote:
>> diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
>> index 947e79b..26b52ec 100644
>> --- a/drivers/mfd/rtsx_pcr.h
>> +++ b/drivers/mfd/rtsx_pcr.h
>> @@ -63,4 +63,12 @@ static inline u8 map_sd_drive(int idx)
>>   #define rtl8411_reg_to_sd30_drive_sel_3v3(reg)	(((reg) >> 5) & 0x07)
>>   #define rtl8411b_reg_to_sd30_drive_sel_3v3(reg)	((reg) & 0x03)
>>   
>> +#define set_pull_ctrl_tables(__device)				\
>> +do {								\
>> +	pcr->sd_pull_ctl_enable_tbl  = __device##_sd_pull_ctl_enable_tbl;  \
>> +	pcr->sd_pull_ctl_disable_tbl = __device##_sd_pull_ctl_disable_tbl; \
>> +	pcr->ms_pull_ctl_enable_tbl  = __device##_ms_pull_ctl_enable_tbl;  \
>> +	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl; \
>> +} while (0)
>> +
>>   #endif
> This is nasty...  With readable code, you should understand just from
> looking at it what the code is doing but this obscures it completely.
> It shouldn't reference the "pcr" variable without passing it in as an
> argument but even with that cleanup I don't really like it.
>
> To be honest, I don't see the problem with the original code.
>
>
Using macro can reduce some code, and define as set_pull_ctl_tables(pcr, 
dev)
is much better for understand
