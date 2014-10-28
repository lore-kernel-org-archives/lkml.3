Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaJ1PFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:05:22 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:11744 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaJ1PFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:05:20 -0400
Message-ID: <544FB0AC.4020205@imgtec.com>
Date: Tue, 28 Oct 2014 15:05:16 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Clemens Ladisch <clemens@ladisch.de>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Neil Jones <neil.jones@imgtec.com>
Subject: Re: [PATCH 00/11] Add AXD Audio Processing IP driver
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com> <544F8439.4080402@ladisch.de> <544F97A4.7080209@imgtec.com> <20141028141348.GD18384@kroah.com>
In-Reply-To: <20141028141348.GD18384@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 02:13 PM, Greg Kroah-Hartman wrote:
> On Tue, Oct 28, 2014 at 01:18:28PM +0000, Qais Yousef wrote:
>> On 10/28/2014 11:55 AM, Clemens Ladisch wrote:
>>> Qais Yousef wrote:
>>>> AXD Audio Processing IP performs audio decoding, encoding, mixing, equalisation,
>>>> synchronisation and playback.
>>> What exactly do you mean with "synchronisation" and "playback"?
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
>>> ... because those two words sound like something that a sound card could do.
>> The problem mainly stems from the fact that we take a variety of
>> compressed audio as input and we could perform audio encoding. The
>> problem with the compressed audio is that the range of decoders and
>> configuration supported in alsa is limited and there's no support for
>> taking raw pcm and producing compressed output. I'm not an expert on
>> alsa but when I looked it looked like there's more infra structure
>> required.
>>
>> The following not supported points from Documentation/sound/alsa/compress_offload.txt affect us:
>>
>> - Volume control/routing is not handled by this API. Devices exposing a
>>    compressed data interface will be considered as regular ALSA devices;
>>    volume changes and routing information will be provided with regular
>>    ALSA kcontrols.
>>
>> - Embedded audio effects. Such effects should be enabled in the same
>>    manner, no matter if the input was PCM or compressed.
>>
>> - Encoding/decoding acceleration is not supported as mentioned
>>    above. It is possible to route the output of a decoder to a capture
>>    stream, or even implement transcoding capabilities. This routing
>>    would be enabled with ALSA kcontrols.
> So instead you created a one-off api just for this hardware?  Ick, no,
> please work with the audio developers to incorporate it into the
> standard Linux audio apis so that everyone can benifit and not require
> special userspace programs to drive this hardware.
>
> thanks,
>
> greg k-h

OK. I'll wait to hear from alsa developers to see the extent of work 
required. I can't see it being trivial though. Would it be possible for 
this to be accepted into staging until this is resolved?

Thanks,
Qais
