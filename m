Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab3HZFqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 01:46:34 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:55870
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab3HZFqc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 01:46:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz70kzz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
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
Thread-Index: AQHOnhwezjS9uM7qaEqpBdTwwEdnOZmgDXMAgABm0CCAAFCAAIABpeeAgASVgVA=
Date: Mon, 26 Aug 2013 05:46:26 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827E41E2@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
 <1473340.OXSHEp7d4P@flatron>
 <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130822062610.GR31036@pengutronix.de> <20130823073612.GB3535@ulmo>
In-Reply-To: <20130823073612.GB3535@ulmo>
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

Hi Thierry,


> Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
> Freescale FTM PWM
> 
> On Thu, Aug 22, 2013 at 08:26:10AM +0200, Sascha Hauer wrote:
> > On Thu, Aug 22, 2013 at 02:55:42AM +0000, Xiubo Li-B47053 wrote:
> > > Hi Tomasz,
> > >
> > > Thanks for your comments.
> > >
> > >
> > > > Could you explain meaning of this property more precisely? I'm
> > > > interested especially how is this related to the PWM IP block and
> boards.
> > > >
> > >
> > > Yes.
> > > There are 8 channels most. While the pinctrls of 4th and 5th
> > > channels could be used by uart's Rx and Tx, then these 2 channels
> > > won't be used for pwm output, so there will be 6 channels available
> by the pwm.
> > > Thus, the pwm chip will register only 6 pwms(6 channels)
> > > most("fsl,pwm-channel-orders = {0 1 2 3 6 7}").And also the "fsl,pwm-
> channel-number" will be 6.
> >
> > If the chip has eight PWMs I would register all of them. If some of
> > them are not routed out by the pinmux then just nothing happens if you
> > use them. In a sane devicetree they won't be referenced anyway when
> > they are not routed out of the SoC.
> 
> In that case, shouldn't this be hooked up to the pinctrl subsystem as
> well? As I understand the above, the logical thing would be for each PWM
> channel's .request() operation to configure the pinmuxing appropriately.
> And if it can't be configured as necessary then .request() should return
> an error (or propagate the error from the pinctrl subsystem).
> 

That's maybe better, if so, the pinctrl configuration must be split into two steps:
1, get the channel pinctrl "active" and "idle" states by callig pinctrl_lookup_state() in .request().
2, select the proper state in .enable()/.disable().




Thanks very much.

--
Best Regards.
Xiubo



