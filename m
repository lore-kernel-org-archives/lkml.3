Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab3H0Ds6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:48:58 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:11301
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705Ab3H0Ds4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:48:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: RE: [PATCH 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM
Thread-Topic: [PATCH 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM
Thread-Index: AQHOnhwezjS9uM7qaEqpBdTwwEdnOZmgDXMAgABm0CCAAFCAAIABpeeAgADHM4CAA8nKEIAA9i2AgABz/iA=
Date: Tue, 27 Aug 2013 03:48:51 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827E61F2@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
 <1473340.OXSHEp7d4P@flatron>
 <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130822062610.GR31036@pengutronix.de> <20130823073612.GB3535@ulmo>
 <5217B807.7020800@wwwdotorg.org>
 <1DD289F6464F0949A2FCA5AA6DC23F827E11AC@039-SN2MPN1-012.039d.mgd.msft.net>
 <521BB40D.7040001@wwwdotorg.org>
In-Reply-To: <521BB40D.7040001@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.56]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,


> Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
> Freescale FTM PWM
> 
> On 08/25/2013 11:35 PM, Xiubo Li-B47053 wrote:
> >> Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
> ...
> >>> Why do you need to manipulate the pinctrl to en/disable a channel?
> >>
> >> This is because in Vybrid VF610 TOWER board, there are 4 leds, and
> >> each led's one point(diode's positive pole) is connected to 3.3V, and
> >> the other point is connected to pwm's one channel. When the 4
> >> pinctrls are configured as enable at the same time, the 4 pinctrls is
> >> low valtage, and the 4 leds will be lighted up as default, then when
> >> you enable/disable one led will effects others.
> >>
> >> These pinctrls are belong to pwm, and I don't think led or other
> >> customer could control them directly.
> >> So, here I authorize the 4 pinctrls to each channel controls.
> >>
> > "
> > For the reason above, I have to control the pinctrls separately.
> >
> > If all the pinctrls set as default state, the 8 pinctrls must be
> controlled together.
> > And the 4 leds will all be lighted up as default and will influence
> each other.
> 
> Sorry, that still doesn't make much sense. Either way though, having
> separate pinctrl setup for a single device isn't going to work. You'll
> either need to have all combinations of 4 (8?) PWMs represented as
> pinctrl states(!), or register separate PWM devices so that they get
> independant pinctrl states.
>
Well, I have ever thought about registering separate PWM device for each channel.
But, if so, how should I control the pinctrl of each PWM(actually one channel of FTM PWM) ?
I must select "default" state(the "default" state here, the pinctrl must be setup as "dsN" or "chN-idle" state we discussed before) when probing, and when customers .request-->.config-->.enable the PWM I also must select an "active" state to config the pinctrl...
Thus, this is still not static. I think this isn't much different from the current.

Also if having all combinations of 8 PWMs represented as pinctrl states, how could I deal with the problem about LEDs ?



Thanks very much,

--
Best Regards,
Xiubo

