Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaC0CgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:36:10 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:41679
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbaC0CgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:36:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275dh1de097h186068hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh1155h)
Date: Thu, 27 Mar 2014 10:29:36 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: David Laight <David.Laight@ACULAB.COM>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_sai: Add isr to deal with error
 flag
Message-ID: <20140327022934.GA16197@MrMyself>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6E958E@AcuExch.aculab.com>
 <20140327011424.GB30768@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140327011424.GB30768@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 01:14:24AM +0000, Mark Brown wrote:
> On Wed, Mar 26, 2014 at 11:59:53AM +0000, David Laight wrote:
> > From: Nicolin Chen
> 
> > > +	regmap_read(sai->regmap, FSL_SAI_TCSR, &xcsr);
> > > +	regmap_write(sai->regmap, FSL_SAI_TCSR, xcsr);
> 
> > Assuming these are 'write to clear' bits, you might want
> > to make the write (above) and all the traces (below)
> > conditional on the value being non-zero.
> 
> The trace is already conditional?  I'd also expect to see the driver
> only acknowledging sources it knows about and only reporting that the
> interrupt was handled if it saw one of them - right now all interrupts
> are unconditionally acknowleged.

Will revise it based on the comments from both of you.

Thank you.


> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel


