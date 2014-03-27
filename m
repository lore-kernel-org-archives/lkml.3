Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaC0JmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 05:42:11 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60294 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752785AbaC0JmJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 05:42:09 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mark Brown'" <broonie@kernel.org>
CC: "'Nicolin Chen'" <Guangyu.Chen@freescale.com>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Topic: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Index: AQHPSOkyMNLV7/nE7kymG92arvGYT5rzQwIQgADe8wCAAIzdMA==
Date: Thu, 27 Mar 2014 09:41:20 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6EA538@AcuExch.aculab.com>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6E958E@AcuExch.aculab.com>
 <20140327011424.GB30768@sirena.org.uk>
In-Reply-To: <20140327011424.GB30768@sirena.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown
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

The traces are separately conditional on their own bits.
That is a lot of checks that will normally be false.

Also the driver may need to clear all the active interrupt
bits in order to make the IRQ go away.
It should trace that bits it doesn't expect to be set though.

	David



