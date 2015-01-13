Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbbAMJes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:34:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:12351 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbAMJeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:34:46 -0500
Message-ID: <54B4E658.8070506@atmel.com>
Date: Tue, 13 Jan 2015 17:33:12 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: <alsa-devel@alsa-project.org>, Mark Brown <broonie@kernel.org>,
        <linux-sound@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8904: fix runtime warning
References: <1420793620-2866-1-git-send-email-voice.shen@atmel.com> <20150109111642.GU14516@opensource.wolfsonmicro.com> <54B34035.60107@atmel.com> <54B3943C.4040103@metafoo.de> <54B4AED5.1000001@atmel.com> <54B4DDC9.2000902@metafoo.de>
In-Reply-To: <54B4DDC9.2000902@metafoo.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter Clausen,

On 01/13/2015 04:56 PM, Lars-Peter Clausen wrote:
> On 01/13/2015 06:36 AM, Bo Shen wrote:
>> Hi Lars-Perter Clausen,
>>
>> On 01/12/2015 05:30 PM, Lars-Peter Clausen wrote:
>>> On 01/12/2015 04:32 AM, Bo Shen wrote:
>>> [...]
>>>>>> diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
>>>>>> index 4d2d2b1..38582d7 100644
>>>>>> --- a/sound/soc/codecs/wm8904.c
>>>>>> +++ b/sound/soc/codecs/wm8904.c
>>>>>> @@ -1076,10 +1076,10 @@ static const struct snd_soc_dapm_route
>>>>>> adc_intercon[] = {
>>>>>>       { "Right Capture PGA", NULL, "Right Capture Mux" },
>>>>>>       { "Right Capture PGA", NULL, "Right Capture Inverting Mux" },
>>>>>>
>>>>>> -    { "AIFOUTL", "Left",  "ADCL" },
>>>>>> -    { "AIFOUTL", "Right", "ADCR" },
>>>>>> -    { "AIFOUTR", "Left",  "ADCL" },
>>>>>> -    { "AIFOUTR", "Right", "ADCR" },
>>>>>> +    { "AIFOUTL", NULL, "ADCL" },
>>>>>> +    { "AIFOUTL", NULL, "ADCR" },
>>>>>> +    { "AIFOUTR", NULL, "ADCL" },
>>>>>> +    { "AIFOUTR", NULL, "ADCR" },
>>>>>
>>>>> Is this the right fix here? I am not super familiar with the
>>>>> driver but it appears to contain an "AIFOUTL Mux" control which
>>>>> is not connected to anything. Looks like maybe this is a mistake
>>>>> the mux is indeded to be included in the path? Feels like we
>>>>> should either remove the control as well or hook it into the
>>>>> path.
>>>>
>>>> Thank for your information.
>>>> I think here it should correct the path name as
>>>> --->8---
>>>> { "AIFOUTL Mux", "Left",  "ADCL" },
>>>> { "AIFOUTL Mux", "Right", "ADCR" },
>>>> { "AIFOUTR Mux", "Left",  "ADCL" },
>>>> { "AIFOUTR Mux", "Right", "ADCR" },
>>>> ---8<---
>>>>
>>>> Thanks again. I will send out the new version.
>>>
>>> Your probably also need to connect the mux to the output pins.
>>
>> Thanks for you information, after check the datasheet, I still don't know
>> which the mux should connect to which output pins.
>
> AIFOUTL Mux to AIFOUTL
> AIFOUTR Mux to AIFOUTR

Thanks. I will send new version patch for review.

Best Regards,
Bo Shen

