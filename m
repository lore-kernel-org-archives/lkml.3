Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab3CYXQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:16:00 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:35558 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063Ab3CYXP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:15:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CWE-Q0Oh_LnP3ZOcnm5D68rJ6JGun=Tpq4EbS4TDQ+bw@mail.gmail.com>
References: <51502C87.8050902@digi.com>
	<CAOMZO5CWE-Q0Oh_LnP3ZOcnm5D68rJ6JGun=Tpq4EbS4TDQ+bw@mail.gmail.com>
Date: Mon, 25 Mar 2013 20:15:58 -0300
Message-ID: <CAOMZO5CvrkfGPi7=4-JXnSLzU+8NKV=RD9n3eLvCehXdv6JHEg@mail.gmail.com>
Subject: Re: BUG: soft lockup when recording audio on MX28EVK with ASoC sgtl5000
From: Fabio Estevam <festevam@gmail.com>
To: Hector Palacios <hector.palacios@digi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, alsa-devel@alsa-project.org,
        Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <b29396@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hector,

On Mon, Mar 25, 2013 at 4:31 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Hector,
>
> On Mon, Mar 25, 2013 at 7:52 AM, Hector Palacios
> <hector.palacios@digi.com> wrote:
>> Hello,
>>
>> I just tried recording audio on Freescale's MX28EVK that uses ASoC sgtl5000
>> (kernel v3.8) with:
>>
>>         arecord -M -f cd sound.wav --duration 10
>>
>> and got a scheduler message:
>>
>> [  789.041847] [sched_delayed] sched: RT throttling activated
>
> I have just tested arecord on 3.8,4 and I haven't seen the 'soft lockup' bug.
>
> However, I see that mxs saif gets busy after the record and any
> attempt to do an 'aplay' after the first arecord fails.
>
> With the attached patch applied I am able to do arecord/aplay sequence
> several times.
>
> I don't have a cable handy here to actually test if the sound is
> recorded properly or not.
>
> Could you please test it against 3.8.4?

I managed to test arecord and it works with the following as follows:

1. Run alsamixer and select LINE_IN in the Capture element

2. Record with the following command line:

arecord -D hw:0,1 -d 10 -f S16_LE -r 44100 -c  test.wav

3. Then listen test.wav on your PC or in your board itself.

The sequence above works fine.

Anyway, I will submit the patch I sent earlier as it prevents the
system to get unresponsive.

Regards,

Fabio Estevam
