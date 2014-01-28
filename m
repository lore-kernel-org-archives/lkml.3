Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaA1KTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:19:43 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59431 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaA1KTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:19:09 -0500
Message-ID: <52E78418.3000302@gmail.com>
Date: Tue, 28 Jan 2014 19:19:04 +0900
From: Daniel Jeong <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Daniel Jeong <gshark.jeong@gmail.com>
Subject: Re: [RFCv2,1/2] v4l2-controls.h: add addtional Flash fault bits
References: <1390892158-5646-1-git-send-email-gshark.jeong@gmail.com> <20140128090841.GG13820@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140128090841.GG13820@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014년 01월 28일 18:08, Sakari Ailus 쓴 글:
> Hi Daniel,
>
> On Tue, Jan 28, 2014 at 03:55:57PM +0900, Daniel Jeong wrote:
>> Add additional FLASH Fault bits to dectect faults from chip.
>> Some Flash drivers support UVLO, IVFM, NTC Trip faults.
>> UVLO : 	Under Voltage Lock Out Threshold crossed
>> IVFM : 	IVFM block reported and/or adjusted LED current Input Voltage Flash Monitor trip threshold
>> NTC  : 	NTC Threshold crossed. Many Flash drivers have a pin and the fault bit to
>> serves as a threshold detector for negative temperature coefficient (NTC) thermistors.
>>
>> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
>> ---
>>   include/uapi/linux/v4l2-controls.h |    3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
>> index 1666aab..01d730c 100644
>> --- a/include/uapi/linux/v4l2-controls.h
>> +++ b/include/uapi/linux/v4l2-controls.h
>> @@ -803,6 +803,9 @@ enum v4l2_flash_strobe_source {
>>   #define V4L2_FLASH_FAULT_SHORT_CIRCUIT		(1 << 3)
>>   #define V4L2_FLASH_FAULT_OVER_CURRENT		(1 << 4)
>>   #define V4L2_FLASH_FAULT_INDICATOR		(1 << 5)
>> +#define V4L2_FLASH_FAULT_UVLO			(1 << 6)
>> +#define V4L2_FLASH_FAULT_IVFM			(1 << 7)
>> +#define V4L2_FLASH_FAULT_NTC_TRIP		(1 << 8)
> I object adding a new fault which is essentially the same as an existing
> fault, V4L2_FLASH_FAULT_OVER_TEMPERATURE.

I hope you consider it again.
Usually, when the die temperature exceeds the specific temperature, ie 120 or 135 and fixed value,
turn off PFET,NFET, current sources and set TEMP Fault bit.
But in the NTC mode, the comparator is working and detect selected temperature through Vtrip value.
It protects shutdown the chip due to high voltage and keep the device operation.
Many flash chip support NTC and TEMP Fault both. For example, LM3554, LM3556, LM3559
LM3642, LM3646, LM3560, LM3561, LM3565 etc
Two things should be tell apart.

>
> As the practice has been to use human-readable names for the faults, I'd
> also suggest using V4L2_FLASH_FAULT_UNDER_VOLTAGE instead of
> V4L2_FLASH_FAULT_UVLO.

I agree with you.

>
> What's the IVFM block and what does it do?

IVFM is Input Voltage Flash Monitor.
If the flash chip has IVFM function the flash current can be adjusted based upon the voltage level of input.
As ramping flash current, the input voltage goes down and IVFM block adjust current to prevent to shudown due to low voltage
and keep the flash operation. So if the input voltage crossed the IVFM Threshold level chip set the fault bit.
Many flash chip, for example LM3556, LM3646, LM3642 , support this fucntion.
I think, V4L2_FLASH_FAULT_INPUT_VOLTAGE_MONITOR is better than V4L2_FLASH_FAULT_IVFM.

>
>>   #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
>>   #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)

