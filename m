Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaKDLlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:41:16 -0500
Received: from s250.sam-solutions.net ([217.21.49.219]:56776 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaKDLlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:41:14 -0500
From: Dmitry Lavnikevich <D.Lavnikevich@sam-solutions.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH v5 2/3] ARM: dts: pbab01: enable I2S audio on
 phyFLEX-i.MX6 boards
Thread-Topic: [PATCH v5 2/3] ARM: dts: pbab01: enable I2S audio on
 phyFLEX-i.MX6 boards
Thread-Index: AQHP837byG6yn/QTxEG6I1dcN2Hgn5xOQX6AgAHtgIA=
Date: Tue, 4 Nov 2014 11:40:32 +0000
Message-ID: <76742380-95D6-4E0C-8622-E9FA27993A42@sam-solutions.com>
References: <1414590424-25585-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1414590424-25585-3-git-send-email-d.lavnikevich@sam-solutions.com>
 <20141103061408.GA21210@tiger>
In-Reply-To: <20141103061408.GA21210@tiger>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.109.108]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21147BB21AF23B4987237294F68A1FEC@sam-solutions.net>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On 3Nov, 2014, at 09:14, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Wed, Oct 29, 2014 at 04:47:03PM +0300, Dmitry Lavnikevich wrote:
>> +		fsl,audmux-port = <4>;
>> +		fsl,port-config = <
>> +			0x00000000
>> +			IMX_AUDMUX_V2_PDCR_RXDSEL(1)
>> +		>;
>> +	};
>> +};
>> +
>> &i2c2 {
>> 	status = "okay";
>> 
>> -	tlv320@18 {
>> -		compatible = "ti,tlv320aic3x";
>> +	codec: tlv320@18 {
>> +		compatible = "ti,tlv320aic3007";
> 
> Both compatible strings are documented in
> Documentation/devicetree/bindings/sound/tlv320aic3x.txt.  But I hope
> this change will not cause any DT compatible issues.

This change is needed because unlike other tlv320aic3x-codecs tlv320aic3007 has D-class amplifier which is controlled by set of registers that in case of 3x-codecs control mono output.

I will correct patches according to other notes and soon will resend patchset.