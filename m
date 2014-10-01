Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaJANki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:40:38 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:54068 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaJANkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:40:36 -0400
Message-ID: <542C0441.5080508@sam-solutions.com>
Date: Wed, 1 Oct 2014 16:40:17 +0300
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Organization: SaM Solutions
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/4] ARM: dts: pbab01: enable I2S audio on phyFLEX-i.MX6
 boards
References: <1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>	<1410854903-26419-1-git-send-email-d.lavnikevich@sam-solutions.com>	<1410854903-26419-3-git-send-email-d.lavnikevich@sam-solutions.com> <CAOMZO5CgrQ6Wf6kStga40TUKx9dARygCNB4OYSUoG3c8eUYbrA@mail.gmail.com>
In-Reply-To: <CAOMZO5CgrQ6Wf6kStga40TUKx9dARygCNB4OYSUoG3c8eUYbrA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/14 15:11, Fabio Estevam wrote:
> On Tue, Sep 16, 2014 at 5:08 AM, Dmitry Lavnikevich
> <d.lavnikevich@sam-solutions.com> wrote:
>
>> +       regulators {
>> +               sound_1v8: regulator@2 {
>
> We usually start counting from @0.
>
...
 >> +               };
 >> +
 >> +               sound_3v3: regulator@3 {
 >
 > ,so this one should be @1.

@0 and @1 are used for "usb_otg_vbus" and "usb_h1_vbus" regulators in 
dts for phyFLEX module (imx6qdl-phytec-pfla02.dtsi) which gets included 
before base board dts (imx6qdl-phytec-pbab01.dtsi)

>> +                       compatible = "regulator-fixed";
>> +                       reg = <2>;
>> +                       regulator-name = "i2s-audio-1v8";
>> +                       regulator-min-microvolt = <1800000>;
>> +                       regulator-max-microvolt = <1800000>;
>> +                       regulator-always-on;
>
> No need to have this 'regulator-always-on'
>
...
>> +                       compatible = "regulator-fixed";
>> +                       reg = <3>;
>> +                       regulator-name = "i2s-audio-3v3";
>> +                       regulator-min-microvolt = <3300000>;
>> +                       regulator-max-microvolt = <3300000>;
>> +                       regulator-always-on;
>
> No need to have this 'regulator-always-on'
>

why is there no need for 'regulator-alweys-on'? I see it in
similar fixed regulator descriptions in imx6qdl-sabrelite.dtsi,
imx6qdl-wandboard.dtsi, imx6qdl-nitrogen6x.dtsi and many other
boards.

>> +&ssi2 {
>> +       fsl,mode = "i2s-slave";
>
> Please remove this 'fsl,mode' property. It is ignored by the fsl_ssi driver.

yes, thanks. It is present in Documentation but now I see that it
was actually removed not that long ago. I will remove this
property with next patchset.
