Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaC2Kwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 06:52:32 -0400
Received: from smtp-out-096.synserver.de ([212.40.185.96]:1054 "EHLO
	smtp-out-024.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751289AbaC2Kwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 06:52:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 19874
Message-ID: <5336A619.5030007@metafoo.de>
Date: Sat, 29 Mar 2014 11:53:13 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Songhee Baek <sbaek@nvidia.com>
CC: Arun Shamanna Lakshmi <aruns@nvidia.com>,
        "'lgirdwood@gmail.com'" <lgirdwood@gmail.com>,
        "'broonie@kernel.org'" <broonie@kernel.org>,
        "'swarren@wwwdotorg.org'" <swarren@wwwdotorg.org>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "'tiwai@suse.de'" <tiwai@suse.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com> <53332CC7.6060800@metafoo.de> <D6C615D3E4730340AE82D5BD856631C0A26CB319B2@HQMAIL02.nvidia.com> <5333ED3A.7040908@metafoo.de> <5571431004A69147BCABABE4E097D66BA3EFF70CFC@HQMAIL02.nvidia.com> <D6C615D3E4730340AE82D5BD856631C0A26CB31F48@HQMAIL02.nvidia.com>
In-Reply-To: <D6C615D3E4730340AE82D5BD856631C0A26CB31F48@HQMAIL02.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2014 03:30 AM, Songhee Baek wrote:
>> -----Original Message-----
>> From: Songhee Baek
>> Sent: Friday, March 28, 2014 11:10 AM
>> To: 'Lars-Peter Clausen'
>> Cc: Arun Shamanna Lakshmi; 'lgirdwood@gmail.com'; 'broonie@kernel.org';
>> 'swarren@wwwdotorg.org'; 'alsa-devel@alsa-project.org'; 'tiwai@suse.de';
>> 'linux-kernel@vger.kernel.org'
>> Subject: RE: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
>>
>>
>>>> On 03/26/2014 11:41 PM, Songhee Baek wrote:
>>>>>> On 03/26/2014 01:02 AM, Arun Shamanna Lakshmi wrote:
>>>>>>
>>>>>> The way you describe this it seems to me that a value array for
>>>>>> this kind of mux would look like.
>>>>>>
>>>>>> 0x00000000, 0x00000000, 0x00000001 0x00000000, 0x00000000,
>>>>>> 0x00000002 0x00000000, 0x00000000, 0x00000003 0x00000000,
>>>>>> 0x00000000, 0x00000004 0x00000000, 0x00000000, 0x00000008 ...
>>>>>>
>>>>>> That seems to be extremely tedious. If the MUX uses a one hot
>>>>>> encoding how about storing the index of the bit in the values
>>>>>> array and use (1 << value) when writing the value to the register?
>>>>>
>>>>> If we store the index of the bit, the value will be duplicated for
>>>>> each
>>>> registers inputs since register has 0 to 31bits to shift, then we
>>>> need to decode the index to interpret value for which registers to
>>>> set. If we need to interpret the decoded value of index, it is
>>>> better to have custom put/get function in our driver, isn't it?
>>>>>
>>>>
>>>> I'm not sure I understand. If you use (val / 32) to pick the
>>>> register and (val %
>>>> 32) to pick the bit in the register this should work just fine.
>>>> Maybe I'm missing something. Do you have a real world code example
>>>> of of the this type of enum is used?
>>>>
>>>
>>> I can use val/32 and val%32 for this multi register mux.
>>
> With this logic, put function would be easy however get function becomes tedious due to looping on each bit per register for 3 of them in our case. Rather, it would be easy to identify a unique MUX_OFFSET to distinguish between the 3
> registers as shown in the code below.

I'm not sure I understand how that MUX_OFFSET would work. To get the 
selected mux output you can use the ffs instruction.

foreach(reg) {
	reg_val = read(reg) & mask;
	if (reg_val != 0) {
		val = __ffs(reg_val);
		break;
	}
}

- Lars
