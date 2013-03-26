Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab3CZLuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:50:19 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.199]:47065 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757377Ab3CZLuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:50:18 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Mar 2013 07:50:17 EDT
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-11.tower-45.messagelabs.com!1364298229!30913148!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <515189ED.3080807@digi.com>
Date: Tue, 26 Mar 2013 12:43:41 +0100
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <b29396@freescale.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Subject: Re: BUG: soft lockup when recording audio on MX28EVK with ASoC sgtl5000
References: <51502C87.8050902@digi.com> <CAOMZO5CWE-Q0Oh_LnP3ZOcnm5D68rJ6JGun=Tpq4EbS4TDQ+bw@mail.gmail.com> <CAOMZO5CvrkfGPi7=4-JXnSLzU+8NKV=RD9n3eLvCehXdv6JHEg@mail.gmail.com>
In-Reply-To: <CAOMZO5CvrkfGPi7=4-JXnSLzU+8NKV=RD9n3eLvCehXdv6JHEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On 03/26/2013 12:15 AM, Fabio Estevam wrote:
> Hector,
>
> On Mon, Mar 25, 2013 at 4:31 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> Hi Hector,
>>
>> On Mon, Mar 25, 2013 at 7:52 AM, Hector Palacios
>> <hector.palacios@digi.com> wrote:
>>> Hello,
>>>
>>> I just tried recording audio on Freescale's MX28EVK that uses ASoC sgtl5000
>>> (kernel v3.8) with:
>>>
>>>          arecord -M -f cd sound.wav --duration 10
>>>
>>> and got a scheduler message:
>>>
>>> [  789.041847] [sched_delayed] sched: RT throttling activated
>>
>> I have just tested arecord on 3.8,4 and I haven't seen the 'soft lockup' bug.
>>
>> However, I see that mxs saif gets busy after the record and any
>> attempt to do an 'aplay' after the first arecord fails.
>>
>> With the attached patch applied I am able to do arecord/aplay sequence
>> several times.
>>
>> I don't have a cable handy here to actually test if the sound is
>> recorded properly or not.
>>
>> Could you please test it against 3.8.4?
>
> I managed to test arecord and it works with the following as follows:
>
> 1. Run alsamixer and select LINE_IN in the Capture element
>
> 2. Record with the following command line:
>
> arecord -D hw:0,1 -d 10 -f S16_LE -r 44100 -c  test.wav

This command works on v3.8 even without your patch. I can arecord/aplay several times 
without problems.

With my original command 'arecord [-M] -f cd sound.wav --duration 10', the soft lockup 
appears both in v3.8 and v3.8.4 with and without your patch. So it looks like the 
patch does not help here.

Regards,
-- 
Héctor Palacios
