Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaIBLbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:31:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44366 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbaIBLbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:31:49 -0400
Date: Tue, 2 Sep 2014 12:31:44 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "varkabhadram@gmail.com" <varkabhadram@gmail.com>,
        "tklauser@distanz.ch" <tklauser@distanz.ch>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] DTS: serial: Add bindings documention for the
 Mediatek UARTs
Message-ID: <20140902113144.GB7241@leverpostej>
References: <1407852737-17265-1-git-send-email-matthias.bgg@gmail.com>
 <1407852737-17265-3-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407852737-17265-3-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 03:12:17PM +0100, Matthias Brugger wrote:
> This patch adds the devicetree documentation for the Mediatek UART.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  .../devicetree/bindings/serial/mtk-uart.txt        |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/mtk-uart.txt
> 
> diff --git a/Documentation/devicetree/bindings/serial/mtk-uart.txt b/Documentation/devicetree/bindings/serial/mtk-uart.txt
> new file mode 100644
> index 0000000..6ca0e15
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/mtk-uart.txt
> @@ -0,0 +1,20 @@
> +* Mediatek Universal Asynchronous Receiver/Transmitter (UART)
> +
> +Required properties:
> +- compatible: "mediatek,mt6577-uart"
> +  Compatibility with mt6577, mt6589, mt6582
> +
> +- reg: The base address of the UART register bank.
> +
> +- interrupts: A single interrupt specifier.
> +
> +- clocks: Clock driving the hardware.
> +
> +Example:
> +
> +	uart0: serial@11006000 {
> +		compatible = "mediatek,mt6577-uart";
> +		reg = <0x11006000 0x400>;
> +		interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
> +		clocks = <&uart_clk>;
> +	};

This looks generally sane to me. It's simple and doesn't seem to have
any of the usual problems bindings have.

For the mt6577, mt6589, and mt6582, Do you expect to have specific
strings like:

compatible = "mediatek,mt6589-uart", "mediatek,mt6577-uart";

If so, could you update the compatible description to something like:

- compatible: should contain:
  * "mediatek,mt6589-uart" for ...
  * "mediatek,mt6582-uart" for ...
  * "mediatek,mt6577-uart" for all compatible UARTS (mt6589,mt6582,mt6577)

That way the driver just needs to recognise "mediatek,mt6577-uart" for
now but can have quirks later if we discover integration differences.

Cheers,
Mark.
