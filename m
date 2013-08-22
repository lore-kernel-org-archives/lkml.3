Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3HVCzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:55:51 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:9291
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226Ab3HVCzs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:55:48 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
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
Thread-Index: AQHOnhwezjS9uM7qaEqpBdTwwEdnOZmgDXMAgABm0CA=
Date: Thu, 22 Aug 2013 02:55:42 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
 <1473340.OXSHEp7d4P@flatron>
In-Reply-To: <1473340.OXSHEp7d4P@flatron>
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

Hi Tomasz,

Thanks for your comments.


> > +- #pwm-cells: Should be 3. Number of cells being used to specify PWM
> > property.
> > +  First cell specifies the per-chip channel index of the PWM
> > to use, the
> > +  second cell is the period in nanoseconds and bit 0 in
> > the third cell is
> > +  used to encode the polarity of PWM output. Set bit
> > 0 of the third in PWM
> > +  specifier to 1 for inverse polarity & set to 0
> > for normal polarity.
> 
> If the meaning of flags cell is the same as in generic, default PWM
> specifier format, then it should be noted here and generic PWM binding
> documentation mentioned.
> 

OK, How about the following ?
- #pwm-cells: Should be 3. See pwm.txt in this directory for a
  description of the cells format.

I will replace it in v2.


> > +- fsl,pwm-clk-ps: the ftm0 pwm clock's prescaler,
> > divide-by 2^n(n = 0 ~ 7).
> 
> Is it a hardware-specific property?

Yes, I will revise it in v2. 

> 
> > +- fsl,pwm-cpwm: Center-Aligned PWM (CPWM)
> > mode.
> 
> Could you explain meaning of this property?
> 

Well, this feature will be removed from the pwm core in v2.


> > +- fsl,pwm-number: the number of PWM devices, and is must equal to the
> > number +  of "fsl,pwm-channels".
> 
> This is redundant, because you can simply count how many entries have
> been specified in fsl,pwm-channels.
>

Yes, I will revise it in v2.
And this would be renamed to " fsl,pwm-channel-number", which can be more
Readable and understood.

 
> > +- fsl,pwm-channels: the channels' order which is be used for pwm in
> > ftm0 +  module, and they must be one or some of 0 ~ 7, because the
> > ftm0 only has +  8 channels can be used.
> 
> Could you explain meaning of this property more precisely? I'm interested
> especially how is this related to the PWM IP block and boards.
> 

Yes.
There are 8 channels most. While the pinctrls of 4th and 5th channels could be
used by uart's Rx and Tx, then these 2 channels won't be used for pwm output,
so there will be 6 channels available by the pwm.
Thus, the pwm chip will register only 6 pwms(6 channels) most("fsl,pwm-channel-orders
= {0 1 2 3 6 7}").And also the "fsl,pwm-channel-number" will be 6.

If hasn't any other problems, I will revise It in v2.
And this will be renamed to "fsl,pwm-channel-orders", which can be more readable
and understood.

> > +- for very channel, the revlatived the pinctrl should be at least two
>                            ^ typo?
> 
> > state +  {"enN", "dsN"}, which "en" means "enable", "ds" means
> > "disable" and "N" +  means the order of the channel.
> 
> I'd suggest a more readable naming convention, for example chN-active and
> chN-idle. These words seem to be more common across existing bindings.
> 

That's a good idea, I will think it over and revise it in v2.


Thanks very much.
--
Best Regards,
Xiubo

