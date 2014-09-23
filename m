Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaIWLQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:16:09 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37915 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbaIWLQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:16:06 -0400
Date: Tue, 23 Sep 2014 13:15:00 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Carlo Caione <carlo@caione.org>,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: net: stmmac glue layer for Amlogic Meson SoCs
Message-ID: <20140923111459.GA4487@gmail.com>
References: <1411219757-9201-1-git-send-email-b.galvani@gmail.com>
 <54211032.6010009@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54211032.6010009@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 08:16:18AM +0200, Giuseppe CAVALLARO wrote:
> On 9/20/2014 3:29 PM, Beniamino Galvani wrote:
> >Hi,
> >
> >the Ethernet controller available in Amlogic Meson6 and Meson8 SoCs is
> >a Synopsys DesignWare MAC IP core, already supported by the stmmac
> >driver.
> >
> >These patches add a glue layer to the driver for the platform-specific
> >settings required by the Amlogic variant.
> >
> >This has been tested on a Amlogic S802 device with the initial Meson
> >support submitted by Carlo Caione [1].
> 
> patches look fine just a warning with checkpatch as shown below then
> 
> Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> 
> 
> [cavagiu@lxmcdt5 net.git]$ git-format-patch -2
> 0001-net-stmmac-add-Amlogic-Meson-glue-layer.patch
> 0002-net-stmmac-meson-document-device-tree-bindings.patch
> [cavagiu@lxmcdt5 net.git]$ !./
> ./scripts/checkpatch.pl 000*
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #57:
> new file mode 100644
> 
> WARNING: DT compatible string vendor "amlogic" appears un-documented
> -- check ./Documentation/devicetree/bindings/vendor-prefixes.txt
> #152: FILE: drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:34:
> +	{ .compatible = "amlogic,meson6-dwmac", .data = &meson6_dwmac_data},

Hi Giuseppe,

thanks for the review. The amlogic vendor prefix is documented as part
of the initial Meson support in the series reported in the cover
letter.

Beniamino

> 
> total: 0 errors, 2 warnings, 0 checks, 108 lines checked
> 
> 0001-net-stmmac-add-Amlogic-Meson-glue-layer.patch has style
> problems, please review.
> 
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #17:
> new file mode 100644
> 
> total: 0 errors, 1 warnings, 25 lines checked
> 
> 0002-net-stmmac-meson-document-device-tree-bindings.patch has style
> problems, please review.
> 
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> >
> >[1] http://lwn.net/Articles/612000/
> >
> >Beniamino Galvani (2):
> >   net: stmmac: add Amlogic Meson glue layer
> >   net: stmmac: meson: document device tree bindings
> >
> >  .../devicetree/bindings/net/meson-dwmac.txt        | 25 ++++++++
> >  drivers/net/ethernet/stmicro/stmmac/Kconfig        | 10 ++++
> >  drivers/net/ethernet/stmicro/stmmac/Makefile       |  1 +
> >  drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c  | 67 ++++++++++++++++++++++
> >  drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  3 +
> >  .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  3 +
> >  6 files changed, 109 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/meson-dwmac.txt
> >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
> >
> 
