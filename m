Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab3IRXdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:33:13 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:57699
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897Ab3IRXdL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:33:11 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zz98dIc89bh936eI146fI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz17326ah1de097h186068h5eeeK8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Wed, 18 Sep 2013 16:32:59 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Joe Perches <joe@perches.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v2] clk: si570: Add a driver for SI570 oscillators
References: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
 <1379545361.1787.87.camel@joe-AO722>
 <0da25c5c-660c-4836-8179-6e7c51fd0d9f@CO9EHSMHS005.ehs.local>
 <1379546336.1787.95.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1379546336.1787.95.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <1119f60e-99dd-45f8-8d91-2b0fa8b7f03b@DB8EHSMHS027.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 04:18:56PM -0700, Joe Perches wrote:
> On Wed, 2013-09-18 at 16:09 -0700, Sören Brinkmann wrote:
> > On Wed, Sep 18, 2013 at 04:02:41PM -0700, Joe Perches wrote:
> > > On Wed, 2013-09-18 at 15:43 -0700, Soren Brinkmann wrote:
> > > > Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> > > > The devices generate low-jitter clock signals and are reprogrammable via
> > > > an I2C interface.
> > > []
> > > > v2:
> > > []
> > > >  - use 10000 as MIN and MAX value in usleep_range
> > > []
> > > > diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
> > > []
> > > > +static int si570_set_frequency(struct clk_si570 *data, unsigned long frequency)
> > > > +{
> > > []
> > > > +	/* Applying a new frequency can take up to 10ms */
> > > > +	usleep_range(10000, 10000);
> > > 
> > > Generally it's nicer to have an actual range for usleep_range.
> > Well, as I said in the discussion with Guenther. I'm flexible and nobody
> > objected when I said to make both equal. A real range doesn't make sense
> > here though, but I don't know what's common practice for cases like
> > this.
> 
> udelay is normal, but I guess you don't need atomic context.
After checkpatch correcting me a few times I went with what
Documentation/timers/timers-howto.txt suggests. But yes, then we have
this situation, that I want to sleep 10ms, but not longer using a
*_range function. I guess it is very application specific whether a
longer delay here is acceptable or not.

>  
> > > Is there a bit you could periodically poll to see
> > > if the new frequency has been set or is stable so
> > > that a 10ms delay isn't always used?
> 
> > Unfortunately not.
> 
> Thanks.  I suppose I should read the datasheets before asking.
> 
> http://www.silabs.com/Support%20Documents/TechnicalDocs/si570.pdf
> (page 12)
> 
> Anyway, perhaps si570_set_frequency_small needs a delay too.'
> 
> The 570 datasheet says it needs a 100uS delay.
You're right. I'll add a delay there as well. The 'rang' question
applies here as well.

	Sören


