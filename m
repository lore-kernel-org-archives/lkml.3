Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbbAOEk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:40:57 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:47923 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbAOEk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:40:56 -0500
Message-ID: <54B744D1.3040809@mentor.com>
Date: Thu, 15 Jan 2015 13:40:49 +0900
From: jiwang <jiada_wang@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Frkuska, Joshua" <Joshua_Frkuska@mentor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Subject: Re: [alsa-devel] unload Audio drivers while playback stream is active
 case kernel crash
References: <857E9EDCA6C0904DB3357321AA9123EB0108B66919@NA-MBX-01.mgc.mentorg.com>	<s5h1tmyiof7.wl-tiwai@suse.de>	<20150113215412.GS4160@sirena.org.uk>	<s5hr3ux24em.wl-tiwai@suse.de>	<54B625A8.8090406@metafoo.de>	<s5hoaq121gh.wl-tiwai@suse.de>	<54B63E4F.2010506@metafoo.de>	<s5hwq4phbzr.wl-tiwai@suse.de>	<20150114120228.GT4160@sirena.org.uk>	<54B6679F.1030706@metafoo.de> <CAOMZO5AQEyb9in0hRn+7zcpE5r8zwVUFjCqAqNOmLMCGYka3Pg@mail.gmail.com>
In-Reply-To: <CAOMZO5AQEyb9in0hRn+7zcpE5r8zwVUFjCqAqNOmLMCGYka3Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On 01/14/2015 10:43 PM, Fabio Estevam wrote:
> On Wed, Jan 14, 2015 at 10:57 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>
>> My personal opinion on this is that disallowing module removal while a
>> driver registered by the module when is in use, while there is no technical
>> reason to do so, is a anti-feature. Whether in ALSA or elsewhere.
>>
>> But looking at the source it seems that this is a core feature of ALSA and
>> at least for the card module itself it will do the ref-counting when a
>> stream is started/stopped. And we even support setting the owner of a card
>> in ASoC. It's just that pretty much no ASoC card driver bothers to set the
>> owner field in the snd_soc_card struct. So this particular problem can be
>> fixed by updating the imx-wm8962 driver to set the owner field.
> Thanks, Lars_Peter. This fixes the issue:
>
> root@freescale /$ modprobe -r snd_soc_imx_wm8962
> modprobe: can't unload module snd_soc_imx_wm8962: Resource temporarily
> unavailable
>
> Will send a patch with your suggestion soon.
I think by set owner field in imx_wm8962 machine driver can fix the 
crash I saw on sabreSD board,
but as this is a generic issue which I suppose should exist on other 
boards with different
machine drivers.

Can we have a more generic fix to this issue?
Or shall we set owner field for all machine drivers?


Thanks,
Jiada
