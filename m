Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3BLDUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 22:20:35 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58880 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3BLDUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 22:20:34 -0500
MIME-Version: 1.0
In-Reply-To: <511934ED.2020104@ti.com>
References: <CABYxbz5ECxoWZtkfL3UbZ=R4LVoNeMVxjYbPdZoarstCod-gQw@mail.gmail.com>
	<5118EF75.30107@ti.com>
	<CABYxbz7HcZTK+y20mtDR+1coRUbUMgNHNDdJ3O7Ln7U7d0LEzA@mail.gmail.com>
	<511934ED.2020104@ti.com>
Date: Tue, 12 Feb 2013 08:50:33 +0530
Message-ID: <CABYxbz7FjutV3zgGYEszzUXMn=Vuk4Vpd3-cP+aVATx5k2yxBQ@mail.gmail.com>
Subject: Re: Sound record on Devkit8000 with DT boot issue
From: Anil Kumar <anilk4.v@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        alsa-devel@alsa-project.org, tony@atomide.com, thomas@tomweber.eu,
        perex@perex.cz, tiwai@suse.de,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Feb 11, 2013 at 11:44 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hi,
>
> On 02/11/2013 06:58 PM, Anil Kumar wrote:
>>> Here you should have something like:
>>> ti,audio-routing =
>>>         "Ext Spk", "PREDRIVEL",
>>>         "Ext Spk", "PREDRIVER",
>>>         "MAINMIC", "Main Mic",
>>>         "Main Mic", "Mic Bias 1";
>>>
>>> So you connect the MicBias1 to Main Mic. When you start playback MicBias1 will
>>> be turned on for you.
>>
>> I tried with this routing (next-20130211 tag kernel). But it is not
>> working for me.
>> So i have gone through other board and found snd_soc_dapm_route for
>>
>> 1) zoom2.c
>>        {"MAINMIC", NULL, "Mic Bias 1"},
>>        {"Mic Bias 1", NULL, "Ext Mic"},

I was giving zoom2 reference from kernel 3.8-rc5.

>>
>> 2) omap3pandora.c
>>         {"MAINMIC", NULL, "Mic Bias 1"},
>>         {"Mic Bias 1", NULL, "Mic (internal)"},

same as above comment.

>>
>> But for omap-twl4030.c it is
>>         {"MAINMIC", NULL, "Main Mic"},
>>         {"Main Mic", NULL, "Mic Bias 1"},
>>
>>  It Should will be as ?
>>         {"MAINMIC", NULL, "Mic Bias 1"},
>>         {"Mic Bias 1", NULL, "Main Mic"},
>>
>> Because with this i am able to get audio on Devkit8000 as
>>              ti,audio-routing =
>>                         "Ext Spk", "PREDRIVEL",
>>                         "Ext Spk", "PREDRIVER",
>>                         "MAINMIC", "Mic Bias 1",
>>                         "Mic Bias 1", "Main Mic";
>
> In 3.9 this should not work...
>
> linux-next should not have zoom2 at least and I converted the machine drivers
> as well in regards to micbias handling:
> e04d6e5 ASoC: twl4030: Convert MICBIAS to SUPPLY widget
> 57d61b9 ASoC: OMAP: Remove obsolete machine drivers for Zoom2 and SDP3430

My board is not botting with linux-next ((next-20130211). So i have
taken omap-twl4030.c changes from next-20130211
and merged into 3.8-rc5 as it does have. But missed changes for
twl4030.c. With these all changes it is working for me now .
Sorry for noise.

I am really thanks for this.
Anil
[...]
