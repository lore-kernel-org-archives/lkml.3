Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaE3IYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:24:07 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16074 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaE3IYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:24:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 30 May 2014 01:16:47 -0700
Date: Fri, 30 May 2014 11:23:56 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] efuse driver for Tegra
Message-ID: <20140530082356.GP5961@tbergstrom-lnx.Nvidia.com>
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com>
 <53878407.3050409@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53878407.3050409@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 09:01:27PM +0200, Stephen Warren wrote:
> On 05/28/2014 06:54 AM, Peter De Schrijver wrote:
> > This driver allows userspace to read the raw efuse data. Its userspace
> > interface is modelled after the sunxi_sid driver which provides similar
> > functionality for some Allwinner SoCs. It has been tested on
> > Tegra20 (ventana), Tegra30 (beaverboard), Tegra114 (dalmore) and
> > Tegra124 (jetson TK1).
> 
> > Changes since v4:
> > 
> > * Provide fallback to hardcoded 0x70000800 in case the apbmisc DT node is
> >   missing. This is exactly what the current code does and prevents a system
> >   crash in that case due to an invalid memory access by tegra_read_chipid()
> 
> Wouldn't it be better to simply return an error?

This would mean you can't boot a system with these patches applied unless you
also update the device tree. The system would crash during boot because CCF
relies on tegra_read_chipid() as an APB barrier. Also tegra_boot_secondary()
relies on the chipid to select the correct method for booting secondary cores.

Cheers,

Peter.
