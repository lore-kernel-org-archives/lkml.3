Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbbASB4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:56:16 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:46093 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbASB4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:56:15 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J1tpnk008287, This message is accepted by code: ctloc85258
From: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 06/10] mfd: rtsx: update phy register
Thread-Topic: [PATCH 06/10] mfd: rtsx: update phy register
Thread-Index: AQHQMxp6FjKtWIsBHka3fJmxZldZbpzGKcgA
Date: Mon, 19 Jan 2015 01:55:50 +0000
Message-ID: <54BC6426.40902@realsil.com.cn>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <38141c346f29fcf48b4dc168c1841c8732c70b4c.1421320541.git.micky_ching@realsil.com.cn>
 <20150118122947.GM3574@x1>
In-Reply-To: <20150118122947.GM3574@x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="utf-8"
Content-ID: <497DAE7455C0264F8714C0DAB2285849@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J1uLes032676


On 01/18/2015 08:29 PM, Lee Jones wrote:
> On Thu, 15 Jan 2015, micky_ching@realsil.com.cn wrote:
>
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> update phy register value and using direct value instead of macros.
>> It is much easier to debug using constant value than a lot of macros.
>> We usually need compare the value directly to check the configure.
> NACK.  This is the opposite of what I would like to see.
>
When we debug, we usually need to compare the value provided from hardware,
of course we can compare by print them to kernel log. but I think it more
convenient from source code. And we only set phy register when 
initialize chip,
so the value will not scattered everywhere, we will not benefit from macros.

if we want to know the meaning of setting, we can look at the register 
define.

>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>> ---
>>   drivers/mfd/rts5249.c | 46 ++++++++++++++--------------------------------
>>   1 file changed, 14 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
>> index 2fe2854..00208d1 100644
>> --- a/drivers/mfd/rts5249.c
>> +++ b/drivers/mfd/rts5249.c
>> @@ -132,57 +132,39 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
>>   	if (err < 0)
>>   		return err;
>>   
>> -	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV,
>> -			PHY_REG_REV_RESV | PHY_REG_REV_RXIDLE_LATCHED |
>> -			PHY_REG_REV_P1_EN | PHY_REG_REV_RXIDLE_EN |
>> -			PHY_REG_REV_RX_PWST | PHY_REG_REV_CLKREQ_DLY_TIMER_1_0 |
>> -			PHY_REG_REV_STOP_CLKRD | PHY_REG_REV_STOP_CLKWR);
>> +	err = rtsx_pci_write_phy_register(pcr, 0x19, 0xFE6C);
>>   	if (err < 0)
>>   		return err;
>>   
>>   	msleep(1);
>>   
>> -	err = rtsx_pci_write_phy_register(pcr, PHY_BPCR,
>> -			PHY_BPCR_IBRXSEL | PHY_BPCR_IBTXSEL |
>> -			PHY_BPCR_IB_FILTER | PHY_BPCR_CMIRROR_EN);
>> +	err = rtsx_pci_write_phy_register(pcr, 0x0A, 0x05C0);
>>   	if (err < 0)
>>   		return err;
>> -	err = rtsx_pci_write_phy_register(pcr, PHY_PCR,
>> -			PHY_PCR_FORCE_CODE | PHY_PCR_OOBS_CALI_50 |
>> -			PHY_PCR_OOBS_VCM_08 | PHY_PCR_OOBS_SEN_90 |
>> -			PHY_PCR_RSSI_EN);
>> +
>> +	err = rtsx_pci_write_phy_register(pcr, 0x00, 0xBA43);
>> +	if (err < 0)
>> +		return err;
>> +	err = rtsx_pci_write_phy_register(pcr, 0x03, 0xC152);
>>   	if (err < 0)
>>   		return err;
>> -	err = rtsx_pci_write_phy_register(pcr, PHY_RCR2,
>> -			PHY_RCR2_EMPHASE_EN | PHY_RCR2_NADJR |
>> -			PHY_RCR2_CDR_CP_10 | PHY_RCR2_CDR_SR_2 |
>> -			PHY_RCR2_FREQSEL_12 | PHY_RCR2_CPADJEN |
>> -			PHY_RCR2_CDR_SC_8 | PHY_RCR2_CALIB_LATE);
>> +	err = rtsx_pci_write_phy_register(pcr, 0x1E, 0x78EB);
>>   	if (err < 0)
>>   		return err;
>> -	err = rtsx_pci_write_phy_register(pcr, PHY_FLD4,
>> -			PHY_FLD4_FLDEN_SEL | PHY_FLD4_REQ_REF |
>> -			PHY_FLD4_RXAMP_OFF | PHY_FLD4_REQ_ADDA |
>> -			PHY_FLD4_BER_COUNT | PHY_FLD4_BER_TIMER |
>> -			PHY_FLD4_BER_CHK_EN);
>> +	err = rtsx_pci_write_phy_register(pcr, 0x05, 0x4600);
>>   	if (err < 0)
>>   		return err;
>> -	err = rtsx_pci_write_phy_register(pcr, PHY_RDR, PHY_RDR_RXDSEL_1_9);
>> +	err = rtsx_pci_write_phy_register(pcr, 0x02, 0x041F);
>>   	if (err < 0)
>>   		return err;
>> -	err = rtsx_pci_write_phy_register(pcr, PHY_RCR1,
>> -			PHY_RCR1_ADP_TIME | PHY_RCR1_VCO_COARSE);
>> +	err = rtsx_pci_write_phy_register(pcr, 0x1D, 0x0824);
>>   	if (err < 0)
>>   		return err;
>> -	err = rtsx_pci_write_phy_register(pcr, PHY_FLD3,
>> -			PHY_FLD3_TIMER_4 | PHY_FLD3_TIMER_6 |
>> -			PHY_FLD3_RXDELINK);
>> +	err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4FE4);
>>   	if (err < 0)
>>   		return err;
>> -	return rtsx_pci_write_phy_register(pcr, PHY_TUNE,
>> -			PHY_TUNE_TUNEREF_1_0 | PHY_TUNE_VBGSEL_1252 |
>> -			PHY_TUNE_SDBUS_33 | PHY_TUNE_TUNED18 |
>> -			PHY_TUNE_TUNED12);
>> +
>> +	return 0;
>>   }
>>   
>>   static int rts5249_turn_on_led(struct rtsx_pcr *pcr)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
