Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3D2RyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:54:16 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64815 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832Ab3D2RyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:54:13 -0400
MIME-Version: 1.0
In-Reply-To: <3966422.nINo6Q1vph@avalon>
References: <1366982286-22950-1-git-send-email-prabhakar.csengg@gmail.com> <3966422.nINo6Q1vph@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 29 Apr 2013 23:23:51 +0530
Message-ID: <CA+V-a8umJQhxna6jwLwSXqg_ymKDggmnUdzu_syRfyetFxr_yA@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: adv7343: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Mon, Apr 29, 2013 at 7:32 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Friday 26 April 2013 18:48:06 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> add OF support for the adv7343 driver.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>> ---
>>  .../devicetree/bindings/media/i2c/adv7343.txt      |   69 +++++++++++++++++
>>  drivers/media/i2c/adv7343.c                        |   75 ++++++++++++++++-
>>  2 files changed, 142 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> b/Documentation/devicetree/bindings/media/i2c/adv7343.txt new file mode
>> 100644
>> index 0000000..8426f8d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> @@ -0,0 +1,69 @@
>> +* Analog Devices adv7343 video encoder
>> +
>> +The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead
>> LQFP +package. Six high speed, 3.3 V, 11-bit video DACs provide support for
>> composite +(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs
>> in standard +definition (SD), enhanced definition (ED), or high definition
>> (HD) video +formats.
>> +
>> +The ADV7343 have a 24-bit pixel input port that can be configured in a
>> variety +of ways. SD video formats are supported over an SDR interface, and
>> ED/HD video +formats are supported over SDR and DDR interfaces. Pixel data
>> can be supplied +in either the YCrCb or RGB color spaces.
>> +
>> +Required Properties :
>> +- compatible: Must be "ad,adv7343-encoder"
>> +
>> +Optional Properties :
>> +- ad-adv7343-power-mode-sleep-mode: on enable the current consumption is
>> +                                    reduced to micro ampere level. All DACs
>> +                                    and the internal PLL circuit are
>> +                                    disabled.
>> +- ad-adv7343-power-mode-pll-ctrl: PLL and oversampling control. This
>> +                                  control allows internal PLL 1 circuit to
>> +                                  be powered down and the oversampling to
>> +                                  be switched off.
>> +
>> +- ad-adv7343-power-mode-dac-1: power on/off DAC 1.
>> +- ad-adv7343-power-mode-dac-2: power on/off DAC 2.
>> +- ad-adv7343-power-mode-dac-3: power on/off DAC 3.
>> +- ad-adv7343-power-mode-dac-4: power on/off DAC 4.
>> +- ad-adv7343-power-mode-dac-5: power on/off DAC 5.
>> +- ad-adv7343-power-mode-dac-6: power on/off DAC 6.
>> +- ad-adv7343-sd-config-dac-out-1: Configure SD DAC Output 1.
>> +- ad-adv7343-sd-config-dac-out-2: Configure SD DAC Output 2.
>
> s/ad-/ad,/
>
OK

> Do all those properties really need to be specified at the endpoint level
> instead of the device node level ?
>
Yes.

> I'll let Hans comment on the individual properties, he knows more than I do
> about DACs.
>
>> +Example:
>> +
>> +i2c0@1c22000 {
>> +     ...
>> +     ...
>> +
>> +     adv7343@2a {
>> +             compatible = "ad,adv7343-encoder";
>> +             reg = <0x2a>;
>> +
>> +             port {
>> +                     adv7343_1: endpoint {
>> +                                     /* Active high (Defaults to false) */
>
> Active high ?
>
:-) will fix it.

Regards,
--Prabhakar Lad
