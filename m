Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3F0Iro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:47:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48078 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab3F0Irl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:47:41 -0400
Message-ID: <1372322851.18889.53.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
From: Luciano Coelho <coelho@ti.com>
To: Nishanth Menon <menon.nishanth@gmail.com>
CC: Nishanth Menon <nm@ti.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-arm@vger.kernel.org>
Date: Thu, 27 Jun 2013 11:47:31 +0300
In-Reply-To: <51CBC1C8.1040301@gmail.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
	 <51CBC1C8.1040301@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added mailing lists and everyone back to the thread)

On Wed, 2013-06-26 at 23:38 -0500, Nishanth Menon wrote:
> On 06/25/2013 03:35 AM, Luciano Coelho wrote:
> > +Optional properties:
> > +--------------------
> > +
> > +- refclock: the internal WLAN reference clock frequency (required for
> > +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
> > +  following:
> > +	0 = 19.2 MHz
> > +	1 = 26.0 MHz
> > +	2 = 38.4 MHz
> > +	3 = 52.0 MHz
> > +	4 = 38.4 MHz, XTAL
> > +	5 = 26.0 MHz, XTAL
> > +
> > +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> > +  following:
> > +	0 = 19.200 MHz
> > +	1 = 26.000 MHz
> > +	2 = 38.400 MHz
> > +	3 = 52.000 MHz
> > +	4 = 16.368 MHz
> > +	5 = 32.736 MHz
> > +	6 = 16.800 MHz
> > +	7 = 33.600 MHz
> >
> just a gentle query - why not use frequency itself here in Hz for 
> refclock and txoclk?

I thought about using the actual frequencies, but I decided not to do
so, because I'd have to convert them to these values anyway.  These
values are used to configure the firmware and it uses these
"enumerations".


> might not another option of using
> node {
> clocks=<&clk>;
> }
> 
> Usually refclock is an external clock source, no?

No.  In the WiLink case, both refclock and tcxoclock are internal
clocks.  They are in the module itself and what we need to do is tell
the WiLink chip what the module's clocks look like.


> the above allows you to do an devm_clk_get and clk_get_rate() to figure 
> out the exact clock frequency.

No, we can't use these calls, because they are internal clocks.

Please see my more complete explanation as an answer to Tony's email.

Thanks for your review!

--
Luca.

