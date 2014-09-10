Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaIJRBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:01:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36714 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJRBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:01:22 -0400
Message-ID: <541083EC.7080803@wwwdotorg.org>
Date: Wed, 10 Sep 2014 11:01:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>, Marcel Ziswiler <marcel@ziswiler.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        stefan@agner.ch
Subject: Re: [PATCH 1/3] ASoC: tegra: add tegra sgtl5000 machine driver
References: <cover.1410276224.git.marcel@ziswiler.com>	<f90791ebb1799a4aa62dd6b527885ddadae3c058.1410276224.git.marcel@ziswiler.com> <CAOMZO5BYGwHGSeHeaQxEO=BUBGbno9P29et582SDzmwmfVioZA@mail.gmail.com>
In-Reply-To: <CAOMZO5BYGwHGSeHeaQxEO=BUBGbno9P29et582SDzmwmfVioZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 12:00 PM, Fabio Estevam wrote:
> On Tue, Sep 9, 2014 at 12:28 PM, Marcel Ziswiler <marcel@ziswiler.com> wrote:
>> This binding and driver describe/support playback to headphones, and
>> capture from line-in and microphone.
>>
>> This driver is useful for the Toradex Apalis T30 and Colibri T30 modules.
>>
>> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
>> ---
>>   .../bindings/sound/nvidia,tegra-audio-sgtl5000.txt |  45 +++++
>>   sound/soc/tegra/Kconfig                            |  10 +
>>   sound/soc/tegra/Makefile                           |   2 +
>>   sound/soc/tegra/tegra_sgtl5000.c                   | 216 +++++++++++++++++++++
>
> What about using the simple-audio-card binding instead of adding the
> tegra_sgtl5000 machine driver?
>
> An example of simple-audio-card used with sgtl5000 can be found here:
>
> http://www.spinics.net/lists/devicetree/msg44466.html

I don't think that will work; the Tegra audio complex requires some 
clock management that doesn't immediately seem to fit into the 
simple-audio-card concept.

I had intended to refactor and collapse all the Tegra DT audio bindings 
(and driver code) into a single instance so we didn't need to keep 
adding more and more. However, I unfortunately never got around to that 
and probably won't in the future either. Basically, the binding and code 
would end up essentially identical to any of the current Tegra drivers 
(or the union of them), with a few tweaks such as only creating e.g. a 
headphone jack if a property in DT said to, and moving the sampling 
frequency -> CODEC MCLK table out of the driver into a table in DT. I 
think with those things parameterized in DT, we could get away with a 
single "nvidia,tegra-audio-simple" binding and driver. Such a new 
binding could be based on simple-audio-card with extensions though.
