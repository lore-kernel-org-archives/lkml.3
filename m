Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbaCRRvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:51:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51734 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756707AbaCRRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:51:35 -0400
Date: Tue, 18 Mar 2014 17:51:33 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: Re: [PATCH v2 1/5] drivers: input: keyboard: st-keyscan: add
 keyscan driver
Message-ID: <20140318175133.GE2941@e106331-lin.cambridge.arm.com>
References: <1395154806-2810-1-git-send-email-gabriel.fernandez@st.com>
 <1395154806-2810-2-git-send-email-gabriel.fernandez@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395154806-2810-2-git-send-email-gabriel.fernandez@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 03:00:02PM +0000, Gabriel FERNANDEZ wrote:
> This patch adds ST Keyscan driver to use the keypad hw a subset
> of ST boards provide. Specific board setup will be put in the
> given dt.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
> ---
>  .../devicetree/bindings/input/st-keyscan.txt       |  60 +++++
>  drivers/input/keyboard/Kconfig                     |  12 +
>  drivers/input/keyboard/Makefile                    |   1 +
>  drivers/input/keyboard/st-keyscan.c                | 260 +++++++++++++++++++++
>  4 files changed, 333 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/st-keyscan.txt
>  create mode 100644 drivers/input/keyboard/st-keyscan.c
> 
> diff --git a/Documentation/devicetree/bindings/input/st-keyscan.txt b/Documentation/devicetree/bindings/input/st-keyscan.txt
> new file mode 100644
> index 0000000..51eb428
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/st-keyscan.txt
> @@ -0,0 +1,60 @@
> +* ST Keyscan controller Device Tree bindings
> +
> +The ST keyscan controller Device Tree binding is based on the
> +matrix-keymap.
> +
> +Required properties:
> +- compatible: "st,sti-keyscan"
> +
> +- reg: Register base address and size of st-keyscan controller.
> +
> +- interrupts: Interrupt number for the st-keyscan controller.
> +
> +- clocks: Must contain one entry, for the module clock.
> +  See ../clocks/clock-bindings.txt for details.
> +
> +- pinctrl: Should specify pin control groups used for this controller.
> +  See ../pinctrl/pinctrl-bindings.txt for details.
> +
> +- linux,keymap: The keymap for keys as described in the binding document
> +  devicetree/bindings/input/matrix-keymap.txt.
> +
> +- keypad,num-rows: Number of row lines connected to the keypad controller.
> +
> +- keypad,num-columns: Number of column lines connected to the keypad
> +  controller.
> +
> +Optional property:
> +- st,debounce_us: Debouncing interval time in microseconds

s/_/-/ here, please.

Otherwise this looks ok.

Mark.
