Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3LLIt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:49:27 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:41688 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab3LLItY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:49:24 -0500
Message-ID: <52A97820.8020007@schinagl.nl>
Date: Thu, 12 Dec 2013 09:47:28 +0100
From: Olliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Tejun Heo <tj@kernel.org>, Olliver Schinagl <oliver+list@schinagl.nl>,
        grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        hdegoede@redhat.com, Richard Zhu <r65037@freescale.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl> <1386159055-10264-3-git-send-email-oliver@schinagl.nl> <20131204123708.GD3158@htj.dyndns.org> <529F2677.3070208@schinagl.nl> <20131204131402.GG3158@htj.dyndns.org> <529F2B41.8090009@schinagl.nl> <20131204132312.GH3158@htj.dyndns.org> <52A87C07.1020102@schinagl.nl> <20131212064025.GM18380@S2101-09.ap.freescale.net>
In-Reply-To: <20131212064025.GM18380@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12-12-13 07:40, Shawn Guo wrote:
> On Wed, Dec 11, 2013 at 03:51:51PM +0100, Olliver Schinagl wrote:
>> Working on this and studying the existing
>> ahci_platform/shci_platform drivers the last few days and was
>> figuring out why ahci_platform only supports 1 clock. IMX handles
>> this by having 3 clocks defined in the DT, the first one gets
>> enabled by default via ahci_platform, the other 2 get enabled in
>> IMX's probe function.
>>
>> Is it an idea to extend this to support all clocks that would be
>> required (via a callback)?
> Not really.  We did this for ahci_imx driver only because we do not want
> to churn generic ahci_platform driver with those imx specific setup
> code.  Note, beside the additional two clocks, we have some PHY
> parameters to set up in IMX IOMUXC general purpose registers, and vendor
> specific register HOST_TIMER1MS to be set up as well.
Well many SoC's have these specific things so we need a place to provide 
for this.

The the question then becomes, what do we define as being the common 
clocks? Only the clock for the SATA IP? Or also the clock to which it 
connects to the bus? Where is the line drawn etc.

E.g. a rewritten new ahci-pltfrm.c will support all clocks defined in 
the DT for the ahci node.
>
>> Or do we prefer having the clocks
>> separated for other technical reasons? Or do we want to handle the
>> clocks via the ahci_platform framework and extend hpriv->clk to an
>> array of clocks?
> The direction of the generic ahci platform driver will be having it be
> a library providing helper functions, as discussed as below.
>
> https://lkml.org/lkml/2013/12/6/153
I know, I started this entire thread :p hence my question :)

Oliver
>
> We can ask the helper function to handle the common clocks and leave the
> platform specific ones to platform driver.
>
> Shawn
>

