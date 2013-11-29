Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3K2F6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 00:58:18 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:13477 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878Ab3K2F6O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 00:58:14 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551biz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Li Xiubo <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Shawn Guo <Shawn.Guo@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
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
        Huan Wang <Huan.Wang@freescale.com>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHO304NjulFCIkIhEyiDysSHbIEFZo7QgeAgACKWGA=
Date: Fri, 29 Nov 2013 05:58:09 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F828DD72F@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
 <1384220218-12716-2-git-send-email-Li.Xiubo@freescale.com>
 <20131128212510.GC14689@mithrandir>
In-Reply-To: <20131128212510.GC14689@mithrandir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Thanks for your detail comments.

> > +	switch (fpc->counter_clk_select) {
> > +	case VF610_CLK_FTM0:
> > +		reg |= FTMSC_CLKSYS;
> > +		break;
> > +	case VF610_CLK_FTM0_FIX_SEL:
> > +		reg |= FTMSC_CLKFIX;
> > +		break;
> > +	case VF610_CLK_FTM0_EXT_SEL:
> > +		reg |= FTMSC_CLKEXT;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +	reg |= fpc->clk_ps;
> 
> And another one above this line.
> 
> > +	writel(reg, fpc->base + FTM_SC);
> 
> I think with the proper locking in place what you should do is increment
> counter_clk_enable only here. That makes avoids having to decrement the
> count on error.
> 
> Similarly in fsl_counter_clock_disable() you can postpone decrementing
> the count until the very end.
> 

As the other mails we have talked about this that there are 8 channels
supported, but they share the same counter clock source. So we need to
make sure that when one channel is calling fsl_counter_clock_disable()
it shouldn't disable the counter clock if any other channel is still
enabled. Similary in fsl_counter clock_enable().

This is why I set counter_clk_enable property here.


--
Best Regards,


