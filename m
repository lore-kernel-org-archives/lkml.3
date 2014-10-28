Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaJ1PeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:34:03 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:60403 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaJ1Pd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:33:59 -0400
Message-ID: <544FB763.6040904@imgtec.com>
Date: Tue, 28 Oct 2014 15:33:55 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Clemens Ladisch <clemens@ladisch.de>,
        <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        Neil Jones <neil.jones@imgtec.com>
Subject: Re: [PATCH 00/11] Add AXD Audio Processing IP driver
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com> <544F8439.4080402@ladisch.de> <544F97A4.7080209@imgtec.com> <544FAE35.4000509@metafoo.de>
In-Reply-To: <544FAE35.4000509@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 02:54 PM, Lars-Peter Clausen wrote:
> On 10/28/2014 02:18 PM, Qais Yousef wrote:
>> On 10/28/2014 11:55 AM, Clemens Ladisch wrote:
>>> Qais Yousef wrote:
>>>> AXD Audio Processing IP performs audio decoding, encoding, mixing,
>>>> equalisation,
>>>> synchronisation and playback.
>>> What exactly do you mean with "synchronisation" and "playback"?
>>
>> Synchronisation refers to accurate audio playout relative to a master
>> clock source including compensation of drift between the master clock
>> source and the playout clock of the audio hardware. Hence allowing
>> synchronised audio playout across multiple independent devices.
>>
>> Playback simple refers to the fact that AXD is capable of managing audio
>> playout hardware like I2S and SPDIF interfaces.
>>
>>
>>>> It doesn't fit in alsa subsystem but I Cced them to confirm.
>>> ... because those two words sound like something that a sound card 
>>> could do.
>>
>> The problem mainly stems from the fact that we take a variety of
>> compressed audio as input and we could perform audio encoding. The
>> problem with the compressed audio is that the range of decoders and
>> configuration supported in alsa is limited and there's no support for
>> taking raw pcm and producing compressed output. I'm not an expert on
>> alsa but when I looked it looked like there's more infra structure
>> required.
>>
>> [...]
>
> This doesn't sound to different from any of the other supported audio 
> DSPs. ALSA seems to have 95% of what you need. And the missing 5% is 
> probably stuff that is not specific to your hardware but rather 
> something that other hardware will need as well. The framework is not 
> set in stone you can make modifications and add the features that are 
> missing to make your hardware work.
>
> E.g. look at sound/soc/intel/ for an example of a audio DSP.
>
> No integrating this into ALSA will quite likely result in a quite 
> messy situation for you on the long run.
>
> - Lars
>
>
>
OK thanks for the reference. To be honest it felt like 15-20% of the 
features are missing but I'll need to look at the specifics and 
judge/estimate better.

Thanks,
Qais
