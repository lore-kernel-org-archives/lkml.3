Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaLLXs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:48:57 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59813 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaLLXsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:48:55 -0500
MIME-Version: 1.0
In-Reply-To: <20141212132732.GK11764@sirena.org.uk>
References: <1418271327-14710-1-git-send-email-benzh@chromium.org>
	<1418271327-14710-2-git-send-email-benzh@chromium.org>
	<20141212132732.GK11764@sirena.org.uk>
Date: Fri, 12 Dec 2014 15:48:51 -0800
Message-ID: <CAOV7By+GVAZiqwO9NW3DB87uOzx003K_RPqKhX4+vvf=oB=99A@mail.gmail.com>
Subject: Re: [PATCH 2/3] ASoC: rt5677: add a platform config option for
 MICBIAS voltage
From: Ben Zhang <benzh@google.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Albert Chen <albertchen@realtek.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 5:27 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Dec 10, 2014 at 08:15:26PM -0800, Ben Zhang wrote:
>
>> The MICBIAS voltage for IN1 can be set to 1.476V/2.970V/1.242V/2.475V
>
> The changelog says "platform config" but this is adding DT binding.
>
>> +- realtek,micbias1
>> +  Select 0/1/2/3 to set MICBIAS1 voltage to 1.476V/2.970V/1.242V/2.475V
>> +
>
> Why is this being specified as some magic number rather than using the
> voltage (or at least providing defines for the voltage) - this is going
> to do little to make the DT legible and...
>
>> +enum rt5677_micbias {
>> +     RT5677_MICBIAS_1_476V = 0,
>> +     RT5677_MICBIAS_2_970V = 1,
>> +     RT5677_MICBIAS_1_242V = 2,
>> +     RT5677_MICBIAS_2_475V = 3,
>> +};
>
> ...I see there are defined for platform data.

This patch adds both an entry to the platform data and a DT binding
for MICBIAS level selection. The 4 voltage options
(1.476V/2.970V/1.242V/2.475V) are the only ones supported by the codec
hardware, so it seems an enum is better than specifying the exact
voltage directly. I was following the two examples below:

Documentation/devicetree/bindings/sound/cs42l52.txt (cirrus,micbias-lvl)
Documentation/devicetree/bindings/sound/tlv320aic3x.txt (ai3x-micbias-vg)

I'm new to devicetree bindings. Is there something like an enum in DT?
