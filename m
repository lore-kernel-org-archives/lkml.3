Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3CRPN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:13:59 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:47789
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613Ab3CRPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:13:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 18 Mar 2013 23:13:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <arm@kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Michal Marek <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 1/7] kbuild: create an "include chroot" for DT bindings
Message-ID: <20130318151348.GB4713@S2101-09.ap.freescale.net>
References: <1362594183-21523-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1362594183-21523-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 11:22:57AM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> The recent dtc+cpp support allows header files and C pre-processor
> defines/macros to be used when compiling device tree files. These
> headers will typically define various constants that are part of the
> device tree bindings.
> 
> The original patch which set up the dtc+cpp include path only considered
> using those headers from device tree files. However, most are also
> useful for kernel code which needs to interpret the device tree.
> 
> In both the DT files and the kernel, I'd like to include the DT-related
> headers in the same way, for example, <dt-bindings/gpio/tegra-gpio.h>.
> That will simplify any text which discusses the DT header locations.
> 
> Creating a <dt-bindings/> for kernel source to use is as simple as
> placing files into include/dt-bindings/.
> 
> However, when compiling DT files, the include path should be restricted
> so that only the dt-bindings path is available; arbitrary kernel headers
> shouldn't be exposed. For this reason, create a specific include
> directory for use by dtc+cpp, and symlink dt-bindings from there to the
> actual location of include/dt-bindings/. For want of a better location,
> place this "include chroot" into the existing dts/ directory.
> 
> arch/*/boot/dts/include/dt-bindings -> ../../../../../include/dt-bindings
> 
> Some headers used by device tree files may not be useful to the kernel;
> they may be used simply to aid in constructing the DT file (e.g. macros
> to create a node), but not define any information that the kernel needs
> to share. These may be placed directly into arch/*/boot/dts/ along with
> the DT files themselves.
> 
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Hiroshi Doyu <hdoyu@nvidia.com>
> Acked-by: Michal Marek <mmarek@suse.cz>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> This first patch was previously posted separately as V2. I'm including
> it here to keep it with the whole series. I hope this series can be
> applied as a topic branch in arm-soc.

So no comments on the series means that we can start maintain it on
a topic branch, so that people can base their works on it?

Shawn

