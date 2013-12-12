Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3LLGkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 01:40:05 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33097 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198Ab3LLGj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 01:39:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz8275dh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 12 Dec 2013 14:40:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Olliver Schinagl <oliver@schinagl.nl>
CC: Tejun Heo <tj@kernel.org>, Olliver Schinagl <oliver+list@schinagl.nl>,
        <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <dev@linux-sunxi.org>,
        <maxime.ripard@free-electrons.com>, <ijc@hellion.org.uk>,
        <hdegoede@redhat.com>, Richard Zhu <r65037@freescale.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
Message-ID: <20131212064025.GM18380@S2101-09.ap.freescale.net>
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
 <1386159055-10264-3-git-send-email-oliver@schinagl.nl>
 <20131204123708.GD3158@htj.dyndns.org>
 <529F2677.3070208@schinagl.nl>
 <20131204131402.GG3158@htj.dyndns.org>
 <529F2B41.8090009@schinagl.nl>
 <20131204132312.GH3158@htj.dyndns.org>
 <52A87C07.1020102@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52A87C07.1020102@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 03:51:51PM +0100, Olliver Schinagl wrote:
> Working on this and studying the existing
> ahci_platform/shci_platform drivers the last few days and was
> figuring out why ahci_platform only supports 1 clock. IMX handles
> this by having 3 clocks defined in the DT, the first one gets
> enabled by default via ahci_platform, the other 2 get enabled in
> IMX's probe function.
> 
> Is it an idea to extend this to support all clocks that would be
> required (via a callback)?

Not really.  We did this for ahci_imx driver only because we do not want
to churn generic ahci_platform driver with those imx specific setup
code.  Note, beside the additional two clocks, we have some PHY
parameters to set up in IMX IOMUXC general purpose registers, and vendor
specific register HOST_TIMER1MS to be set up as well.

> Or do we prefer having the clocks
> separated for other technical reasons? Or do we want to handle the
> clocks via the ahci_platform framework and extend hpriv->clk to an
> array of clocks?

The direction of the generic ahci platform driver will be having it be
a library providing helper functions, as discussed as below.

https://lkml.org/lkml/2013/12/6/153

We can ask the helper function to handle the common clocks and leave the
platform specific ones to platform driver.

Shawn

