Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbaCROqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:46:32 -0400
Received: from [216.32.181.183] ([216.32.181.183]:54271 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756200AbaCROq0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:26 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h262fh2668h906i1155h)
From: Harini Katakam <harini.katakam@xilinx.com>
To: Mark Brown <broonie@kernel.org>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>
Subject: RE: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Topic: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Index: AQHPQdlDwreFYNSC5UqDMedDfaXPCprlA1GAgAGtBQKAABjRcoAAHoMQ
Date: Tue, 18 Mar 2014 14:45:09 +0000
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <20140317173017.GW11706@sirena.org.uk>
 <255edf4f-05a8-4d9a-b32d-1a4a8ddaffb5@CH1EHSMHS004.ehs.local>
 <20140318110401.GH11706@sirena.org.uk>
 <d7cf691a-c9cb-4a8a-bf5c-eae952a5d729@VA3EHSMHS045.ehs.local>
 <20140318123348.GR11706@sirena.org.uk>
In-Reply-To: <20140318123348.GR11706@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.229.54]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <aa8486d2-8571-4b31-8980-78806a80e600@CH1EHSMHS031.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Tuesday, March 18, 2014 6:04 PM
> To: Harini Katakam
> Cc: robh+dt@kernel.org; pawel.moll@arm.com; mark.rutland@arm.com;
> ijc+devicetree@hellion.org.uk; galak@codeaurora.org; rob@landley.net;
> grant.likely@linaro.org; devicetree@vger.kernel.org; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> spi@vger.kernel.org; Michal Simek
> Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
> 
> On Tue, Mar 18, 2014 at 12:13:45PM +0000, Harini Katakam wrote:
> 
> 
> > > > In this case both possible interrupt conditions are handled.
> 
> > > Are you sure that's the case, and even if you are that's still not
> > > handling the case where the device isn't flagging an interrupt at all.
> 
> > The IXR_ALL mask is only used to disable all the interrupts in the
> beginning.
> > These two are the only interrupts enabled.
> > And RXNEMPTY status is just polled. That interrupt is not enabled either
> 
> This is all going to be fragile in the face of bugs or changes in the
> code though and like I keep saying it doesn't handle interrupt sharing.

OK. I dint consider interrupt sharing. 
Do you think the following implementation would be better?

status = IRQ_NONE;
if (intr_status & CDNS_SPI_IXR_MODF_MASK) {
	/* Handle this interrupt here */
	status = IRQ_HANDLED;
} else if (intr_status & CDNS_SPI_IXR_TXOW_MASK) {
	/* Handle this interrupt here */
	status = IRQ_HANDLED;
}

return status;

Regards,
Harini


