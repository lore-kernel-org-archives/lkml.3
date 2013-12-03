Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3LCLAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:00:33 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:39733 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3LCLAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:00:30 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rB3B0F2U015324, This message is accepted by code: ctloc85258
Message-ID: <529DBA3D.1040908@realsil.com.cn>
Date: Tue, 3 Dec 2013 19:02:21 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, <rogerable@realtek.com>
Subject: Re: [PATCH v2 2/3] mfd: rtsx: add card reader rtl8402
References: <cover.1386051860.git.micky_ching@realsil.com.cn> <39b168dd315f3b2645d92af29e5ad71789853317.1386051860.git.micky_ching@realsil.com.cn> <20131203104507.GL11828@lee--X1>
In-Reply-To: <20131203104507.GL11828@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 06:45 PM, Lee Jones wrote:
>> From: Micky Ching<micky_ching@realsil.com.cn>
>>
>> Add card reader rtl8042, rtl8402 is much like rtl8411, so just add it to
>> rtl8411.c
>>
>> Signed-off-by: Lee Jones<lee.jones@linaro.org>
> I have never signed this patch off.
>
> These tags actually 'mean' something. Please don't apply them willy-nilly!
ok, I will remove it.
>> Signed-off-by: Micky Ching<micky_ching@realsil.com.cn>
>> ---
>>   drivers/mfd/rtl8411.c  |   33 +++++++++++++++++++++++++++++++++
>>   drivers/mfd/rtsx_pcr.c |    5 +++++
>>   drivers/mfd/rtsx_pcr.h |    1 +
>>   3 files changed, 39 insertions(+)
>>
>> diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
>> index c9eab9d..4b377e3 100644
>> --- a/drivers/mfd/rtl8411.c
>> +++ b/drivers/mfd/rtl8411.c
>> @@ -216,6 +216,31 @@ static int rtl8411_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
>>   	return rtsx_pci_write_register(pcr, LDO_CTL, mask, val);
>>   }
>>   
>> +static int rtl8402_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
>> +{
>> +	u8 mask, val;
>> +	int err;
>> +
>> +	mask = (BPP_REG_TUNED18 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_MASK;
>> +	if (voltage == OUTPUT_3V3) {
>> +		err = rtsx_pci_write_register(pcr,
>> +				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
>> +		if (err < 0)
>> +			return err;
>> +		val = (BPP_ASIC_3V3 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_3V3;
>> +	} else if (voltage == OUTPUT_1V8) {
>> +		err = rtsx_pci_write_register(pcr,
>> +				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
>> +		if (err < 0)
>> +			return err;
>> +		val = (BPP_ASIC_2V0 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_1V8;
>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +
>> +	return rtsx_pci_write_register(pcr, LDO_CTL, mask, val);
>> +}
>> +
> I opposed this on last submission.
>
> Please find a better way to do it.
>
> Ideally, I'd like to see one function for this kind of thing. The
> information required to ensure this is carried out correctly on each
> differing platform can be passed in via a struct instead.
ok, I will add some member to rtsx_pcr to merge the function.
> <snip>
>


-- 
Best Regards
Micky.

