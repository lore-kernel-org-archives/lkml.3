Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3IZCdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:33:09 -0400
Received: from [207.46.163.25] ([207.46.163.25]:39224 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754528Ab3IZCc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:32:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275ch1de098h17326ah1de097h186068h8275bh8275dhz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 26 Sep 2013 10:32:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Frank Li <lznuaa@gmail.com>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PCI host merge strategy and maintainers
Message-ID: <20130926023230.GB21081@S2101-09.ap.freescale.net>
References: <CAErSpo7UX6dt0CPZp3kEQrXXbMeArpu1iFfp=-FX46LVgq0iMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAErSpo7UX6dt0CPZp3kEQrXXbMeArpu1iFfp=-FX46LVgq0iMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Wed, Sep 25, 2013 at 05:28:28PM -0600, Bjorn Helgaas wrote:
> There are patches for exynos, imx6, mvebu, and tegra on the PCI list,
> and I want to sort out how people expect them to be merged.
> 
> My current assumption is the following:
> 
>   drivers/pci/host/pcie-designware.c  via PCI tree since I applied
> recent changes
>   drivers/pci/host/pci-exynos.c  via PCI tree since I applied recent changes
>   drivers/pci/host/pci-imx6.c  via Shawn Guo per [1]

A second thought on that.  I would split the patch for better separation
between driver and arch parts, so that they can go through PCI and
arm-soc tree separately without worrying about merge conflict later.

I will send you patches that we expect to go via your tree in a few
minutes.

Shawn

>   drivers/pci/host/pci-mvebu.c  ?? unclear; Jason Cooper has merged
> some, I've merged some
>   drivers/pci/host/pci-tegra.c  via PCI tree per Stephen Warren [2]
> 
> Please correct anything that's wrong above, and please give me some
> guidance on mvebu.  I'm happy to go either way; I just need to know
> whether to pay attention to them :)
> 
> In addition, since I don't have time, expertise, or hardware to really
> review changes to these drivers, I'd like to have them acked by people
> who do.  My current assumption is that these are the right people:
> 
>   designware: Jingoo Han <jg1.han@samsung.com>
>   exynos: Jingoo Han <jg1.han@samsung.com>
>   imx6: Shawn Guo <shawn.guo@linaro.org>
>   mvebu: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn
> <andrew@lunn.ch>, Gregory Clement <gregory.clement@free-electrons.com>
>   tegra: Thierry Reding <thierry.reding@gmail.com>
> 
> Again, please correct anything that's wrong.  My plan is that I won't
> apply patches to these drivers unless they're acked by the folks
> above.
> 
> Bjorn
> 
> 
> [1] http://lkml.kernel.org/r/20130916091059.GM31147@S2101-09.ap.freescale.net
> [2] http://lkml.kernel.org/r/521CCF9B.9000004@wwwdotorg.org

