Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaCJK5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:57:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62636 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbaCJK5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:57:14 -0400
Date: Mon, 10 Mar 2014 10:56:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "kpc528@gmail.com" <kpc528@gmail.com>,
        "kalluripunnaiahchoudary@gmail.com" 
	<kalluripunnaiahchoudary@gmail.com>,
        "punnaia@xilinx.com" <punnaia@xilinx.com>
Subject: Re: [RFC PATCH] edac: zynq: Added EDAC support for zynq ddr ecc
 controller
Message-ID: <20140310105655.GH14999@e106331-lin.cambridge.arm.com>
References: <4adb2b4b-2ad6-42b9-929e-cc062f817245@TX2EHSMHS021.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4adb2b4b-2ad6-42b9-929e-cc062f817245@TX2EHSMHS021.ehs.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 02:57:16AM +0000, Punnaiah Choudary Kalluri wrote:
> Added EDAC support for reporting the ecc errors of zynq ddr controller.
> The ddr ecc controller corrects single bit errors and detects double bit
> errors
> 
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
>  .../devicetree/bindings/edac/zynq_edac.txt         |   18 +
>  drivers/edac/Kconfig                               |    7 +
>  drivers/edac/Makefile                              |    1 +
>  drivers/edac/zynq_edac.c                           |  613 ++++++++++++++++++++
>  4 files changed, 639 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/edac/zynq_edac.txt
>  create mode 100644 drivers/edac/zynq_edac.c
> 
> diff --git a/Documentation/devicetree/bindings/edac/zynq_edac.txt b/Documentation/devicetree/bindings/edac/zynq_edac.txt
> new file mode 100644
> index 0000000..c21ff83
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/edac/zynq_edac.txt
> @@ -0,0 +1,18 @@
> +Zynq EDAC driver, it does reports the DDR ECC single bit errors that are
> +corrected and double bit ecc errors that are detected by the DDR ECC controller.
> +ECC support for DDR is available in half-bus width(16 bit) configuration only.
> +
> +Required properties:
> +- compatible: Should be "xlnx,ps7-ddrc" or "xlnx,ps7-ddrc-1.00.a"

Is this an or or a xor?

For the former case, which is the most general, which can be used as a
fallback?

How about something like:

- compatible: should contain:
  * "xlnx,ps7-ddrc-1.00.a" for <DESCRIPTION HERE>
  * "xlnx,ps7-ddrc" for any compatible variant

Is there any need at all for the "xlnx,ps7-ddrc" string? The driver
doesn't care about it.

Cheers,
Mark.
