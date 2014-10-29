Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbaJ2PGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:06:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:44745 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbaJ2PGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:06:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,810,1406617200"; 
   d="scan'208";a="627685457"
Message-ID: <5451026B.9030306@linux.intel.com>
Date: Wed, 29 Oct 2014 10:06:19 -0500
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qais Yousef <qais.yousef@imgtec.com>, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org, Neil Jones <neil.jones@imgtec.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 00/11] Add AXD Audio Processing IP driver
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com> <544F8439.4080402@ladisch.de> <544F97A4.7080209@imgtec.com>
In-Reply-To: <544F97A4.7080209@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/14, 8:18 AM, Qais Yousef wrote:
> On 10/28/2014 11:55 AM, Clemens Ladisch wrote:
>> Qais Yousef wrote:
>>> AXD Audio Processing IP performs audio decoding, encoding, mixing,
>>> equalisation,
>>> synchronisation and playback.
>> What exactly do you mean with "synchronisation" and "playback"?
>
> Synchronisation refers to accurate audio playout relative to a master
> clock source including compensation of drift between the master clock
> source and the playout clock of the audio hardware. Hence allowing
> synchronised audio playout across multiple independent devices.
>
> Playback simple refers to the fact that AXD is capable of managing audio
> playout hardware like I2S and SPDIF interfaces.
>
>
>>> It doesn't fit in alsa subsystem but I Cced them to confirm.
>> ... because those two words sound like something that a sound card
>> could do.
>
> The problem mainly stems from the fact that we take a variety of
> compressed audio as input and we could perform audio encoding. The
> problem with the compressed audio is that the range of decoders and
> configuration supported in alsa is limited and there's no support for
> taking raw pcm and producing compressed output. I'm not an expert on
> alsa but when I looked it looked like there's more infra structure
> required.
>
> The following not supported points from
> Documentation/sound/alsa/compress_offload.txt affect us:
>
> - Volume control/routing is not handled by this API. Devices exposing a
>    compressed data interface will be considered as regular ALSA devices;
>    volume changes and routing information will be provided with regular
>    ALSA kcontrols.
>
> - Embedded audio effects. Such effects should be enabled in the same
>    manner, no matter if the input was PCM or compressed.
>
> - Encoding/decoding acceleration is not supported as mentioned
>    above. It is possible to route the output of a decoder to a capture
>    stream, or even implement transcoding capabilities. This routing
>    would be enabled with ALSA kcontrols.

Volume control, effects and routing aren't supported directly with the 
snd_pcm streaming interface either. we didn't add these features either 
in the compressed API since they could be enabled through existing means 
(kcontrols and routing).

>
>
>
>>> I added it to drivers/char as this is the best location I could think
>>> of at the
>>> moment.
>> drivers/misc?
>
> Yeah could do if there's consensus.
>
> Thanks,
> Qais
>
>>
>> Regards,
>> Clemens
>
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel

