Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbbAGRSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:18:38 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:42833 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753180AbbAGRSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:18:36 -0500
Message-ID: <54AD6A5C.60903@arm.com>
Date: Wed, 07 Jan 2015 17:18:20 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
References: <cover.1420628786.git.moinejf@free.fr>	<0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>	<54AD4511.30702@arm.com> <20150107180825.52334d4f@armhf>
In-Reply-To: <20150107180825.52334d4f@armhf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/15 17:08, Jean-Francois Moine wrote:
> On Wed, 07 Jan 2015 14:39:13 +0000
> Andrew Jackson <Andrew.Jackson@arm.com> wrote:
> 
>>> +  - audio-ports: must contain one or two values selecting the source
>>> +	in the audio port.
>>> +	The source type is given by the corresponding entry in
>>> +	the audio-port-names property.  
>>
>> I think that this entry might benefit from a little more explanation.
>> The value specified here selects which pins on the chip provide the
>> audio input doesn't it?  In the outline datasheet that I have these are
>> listed in table 17:
>>
>> Audio port 	Input configuration
>> 		S/PDIF 		I2S-bus
>> AP0 		- 		WS (word select)
>> AP1 		S/PDIF input 	I2S-bus channel 0
>> AP2 		S/PDIF input 	I2S-bus channel 1
>> AP3[1] 				I2S-bus channel 2
>> AP4[1] 				I2S-bus channel 3
>> ACLK 		- 		SCK (I2S-bus clock)
>>
>> [1] Depending on package.
> 
> Your table is close to the one in the TDA9983B documentation I have,
> but the pins are not exactly the same:
> 
> AP0 		WS (word select)
> AP1 		I2S-bus port 0
> AP2 		I2S-bus port 1
> AP3 		I2S-bus port 2
> AP4 		I2S-bus port 3
> AP5		MCLK (master clock for S/PDIF)
> AP6		S/PDIF input
> AP7		AUX (internal test)
> ACLK 		SCK (I2S-bus clock)
> 
> That's why I did not know clearly why I had to set AP2 for S/PDIF input
> and (AP0 + AP1) for I2S input in the Cubox.
> 
> Then, the only more explanation I could give is "have a look at the
> audio input format and at the register 0x1e page 0 in the documentation
> of the TDA998x chip".
> 
> BTW, the tda998x driver supports only the TDA9989, TDA19988 and
> TDA19989 chips. If the TDA9983B would be supported, the audio port
> definitions would be of no use.
> 
> So, what would you see as an explanation?
> 

I understand your difficulty!  I was just wanting something to clarify the 
meaning of the value without reference to the driver source.

You could add something like this to your existing explanation: "The value
describes which audio input pins are selected; this varies depending
on chip type so consult the section on audio port configuration in the 
relevant datasheet.".  

	Andrew

