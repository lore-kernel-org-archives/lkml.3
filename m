Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3BKSPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:15:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50207 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758684Ab3BKSPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:15:09 -0500
Message-ID: <511934ED.2020104@ti.com>
Date: Mon, 11 Feb 2013 19:14:05 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Anil Kumar <anilk4.v@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <tony@atomide.com>,
        <thomas@tomweber.eu>, <perex@perex.cz>, <tiwai@suse.de>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Subject: Re: Sound record on Devkit8000 with DT boot issue
References: <CABYxbz5ECxoWZtkfL3UbZ=R4LVoNeMVxjYbPdZoarstCod-gQw@mail.gmail.com> <5118EF75.30107@ti.com> <CABYxbz7HcZTK+y20mtDR+1coRUbUMgNHNDdJ3O7Ln7U7d0LEzA@mail.gmail.com>
In-Reply-To: <CABYxbz7HcZTK+y20mtDR+1coRUbUMgNHNDdJ3O7Ln7U7d0LEzA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/11/2013 06:58 PM, Anil Kumar wrote:
>> Here you should have something like:
>> ti,audio-routing =
>>         "Ext Spk", "PREDRIVEL",
>>         "Ext Spk", "PREDRIVER",
>>         "MAINMIC", "Main Mic",
>>         "Main Mic", "Mic Bias 1";
>>
>> So you connect the MicBias1 to Main Mic. When you start playback MicBias1 will
>> be turned on for you.
> 
> I tried with this routing (next-20130211 tag kernel). But it is not
> working for me.
> So i have gone through other board and found snd_soc_dapm_route for
> 
> 1) zoom2.c
>        {"MAINMIC", NULL, "Mic Bias 1"},
>        {"Mic Bias 1", NULL, "Ext Mic"},
> 
> 2) omap3pandora.c
>         {"MAINMIC", NULL, "Mic Bias 1"},
>         {"Mic Bias 1", NULL, "Mic (internal)"},
> 
> But for omap-twl4030.c it is
>         {"MAINMIC", NULL, "Main Mic"},
>         {"Main Mic", NULL, "Mic Bias 1"},
> 
>  It Should will be as ?
>         {"MAINMIC", NULL, "Mic Bias 1"},
>         {"Mic Bias 1", NULL, "Main Mic"},
> 
> Because with this i am able to get audio on Devkit8000 as
>              ti,audio-routing =
>                         "Ext Spk", "PREDRIVEL",
>                         "Ext Spk", "PREDRIVER",
>                         "MAINMIC", "Mic Bias 1",
>                         "Mic Bias 1", "Main Mic";

In 3.9 this should not work...

linux-next should not have zoom2 at least and I converted the machine drivers
as well in regards to micbias handling:
e04d6e5 ASoC: twl4030: Convert MICBIAS to SUPPLY widget
57d61b9 ASoC: OMAP: Remove obsolete machine drivers for Zoom2 and SDP3430

-- 
Péter
