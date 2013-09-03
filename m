Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab3ICERQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 00:17:16 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:44677 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab3ICERN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 00:17:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z551biz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
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
        Lu Jingchang-B35083 <B35083@freescale.com>
Subject: RE: [PATCHv2 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv2 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHOpWawpFOEIhAI/kueoxNTb0lp2ZmuB6eAgAO48QCAAGk9gIABGdUA
Date: Tue, 3 Sep 2013 04:17:09 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827F7C59@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1377856132-11290-1-git-send-email-Li.Xiubo@freescale.com>
 <1377856132-11290-2-git-send-email-Li.Xiubo@freescale.com>
 <20130830174909.GF30088@pengutronix.de>
 <1DD289F6464F0949A2FCA5AA6DC23F827F785F@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130902085630.GS30088@pengutronix.de>
In-Reply-To: <20130902085630.GS30088@pengutronix.de>
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

> Subject: Re: [PATCHv2 1/4] pwm: Add Freescale FTM PWM driver support
> 
> On Mon, Sep 02, 2013 at 03:33:37AM +0000, Xiubo Li-B47053 wrote:
> >
> > > > +static void fsl_pwm_free(struct pwm_chip *chip, struct pwm_device
> > > > +*pwm) {
> > > > +	struct fsl_pwm_chip *fpc;
> > > > +	struct fsl_pwm_data *pwm_data;
> > > > +
> > > > +	fpc = to_fsl_chip(chip);
> > > > +
> > > > +	pwm_data = pwm_get_chip_data(pwm);
> > > > +	if (!pwm_data)
> > > > +		return;
> > >
> > > THis check seems unnecessary.
> > >
> >
> > But if do not check it here, I must check it in the following code.
> >
> > > > +
> > > > +	if (pwm_data->available != FSL_AVAILABLE)
> > > > +		return;
> > > > +
> >
> > So the ' struct fsl_pwm_data' may be removed in the future.
> >
> > >
> > > > +
> > > > +
> > > > +	pwm_data->period_cycles = period_cycles;
> > > > +	pwm_data->duty_cycles = duty_cycles;
> > >
> > > These fields are set but never read. Please drop them.
> > >
> > > If you drop the 'available' field also the you can drop chip_data
> > > completely.
> > >
> >
> > I think I may move the 'available' field to the PWM driver data struct.
> 
> You simply don't need the available field. You don't need to track
> whether they are available. If a user enables a pwm which is not routed
> out of the SoC (disabled in the iomux) simply nothing will happen except
> for a slightly increased power consumption.
> 
If the there is not need to explicitly specify the channels are available or not, so there is no doubt that the 'available' field will be dropt.
Why I added this here is because that the 4th and 5th channels' pinctrls are used as UART TX and RX as I have mentioned before, so here if you configure these two pinctrls, the UART TX and RX will be polluted, there maybe some other cases like this.
So, if there is no need to worry about this in PWM driver, the customer should be aware of it and be responsible for the potential risk.
I will think it over and optimize it then.



Thanks very much.
--
Best Regards.
Xiubo





