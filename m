Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaLVCih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:38:37 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42486 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaLVCif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:38:35 -0500
MIME-Version: 1.0
In-Reply-To: <1419007551-10040-2-git-send-email-atull@opensource.altera.com>
References: <1419007551-10040-1-git-send-email-atull@opensource.altera.com> <1419007551-10040-2-git-send-email-atull@opensource.altera.com>
From: Rob Herring <robherring2@gmail.com>
Date: Sun, 21 Dec 2014 20:38:13 -0600
Message-ID: <CAL_Jsq+bwnA14RALT9WWZ=wzt7akjPOJ8s5878CcgkU4EDRC4Q@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] doc: add bindings document for altera fpga manager
To: Alan Tull <atull@opensource.altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>, Mark Brown <broonie@kernel.org>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Kyle Teske <kyle.teske@ni.com>,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Miller <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devel@driverdev.osuosl.org,
        Alan Tull <delicious.quinoa@gmail.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 10:45 AM,  <atull@opensource.altera.com> wrote:
> From: Alan Tull <atull@opensource.altera.com>
>
> New bindings document for Altera fpga manager.
>
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
> v5 : Move bindings to drivers/staging/fpga/Documentation/bindings
>
> v6 : No change in this patch for v6 of the patch set
>
> v7 : No change in this patch for v7 of the patch set
> ---
>  .../Documentation/bindings/altera-fpga-mgr.txt     |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
>
> diff --git a/drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt b/drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
> new file mode 100644
> index 0000000..373af7b
> --- /dev/null
> +++ b/drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
> @@ -0,0 +1,17 @@
> +Altera FPGA Manager
> +
> +Required properties:
> +- compatible : should contain "altr,fpga-mgr"
> +- reg        : base address and size for memory mapped io.
> +               - The first index is for FPGA manager register access.
> +               - The second index is for writing FPGA configuration data.
> +- interrupts : interrupt for the FPGA Manager device.
> +
> +Example:
> +
> +       hps_0_fpgamgr: fpgamgr@0xff706000 {
> +               compatible = "altr,fpga-mgr";

Is "FPGA Manager" what the block is called or the name for the Linux
subsystem?" The name should reflect the h/w block name. Also, is the
block the same in every chip?

This binding doesn't look complex or likely to change, so it can be
out of staging unless you expect it to change.

Rob
