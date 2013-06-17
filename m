Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3FQFuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:50:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60193 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3FQFuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <af7595252de09373f5591f21262e5ffa7c9e0dc2.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
	<af7595252de09373f5591f21262e5ffa7c9e0dc2.1370262666.git.michal.simek@xilinx.com>
Date: Mon, 17 Jun 2013 07:50:21 +0200
Message-ID: <CACRpkdaaZKyqBeJHnL4Q5vc3ZVa_psF61McJ2wsFQJMTGvn-NA@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] DT: Add documentation for gpio-xilinx
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 2:31 PM, Michal Simek <michal.simek@xilinx.com> wrote:

> Describe gpio-xilinx binding.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Changes in v2:
> - Extend description

Thanks, patch applied but look into this:

> +Optional properties:
> +- interrupts : Interrupt mapping for GPIO IRQ.
> +- interrupt-parent : Phandle for the interrupt controller that
> +  services interrupts for this device.
> +- xlnx,all-inputs : if n-th bit is setup, GPIO-n is input
> +- xlnx,dout-default : if n-th bit is 1, GPIO-n default value is 1
> +- xlnx,gpio-width : gpio width
> +- xlnx,tri-default : if n-th bit is 1, GPIO-n is in tristate mode
> +- xlnx,is-dual : if 1, controller also uses the second channel

If is present, xlnx,is-dual;

> +Example:
> +gpio: gpio@40000000 {
> +       #gpio-cells = <2>;
> +       compatible = "xlnx,xps-gpio-1.00.a";
> +       gpio-controller ;
> +       interrupt-parent = <&microblaze_0_intc>;
> +       interrupts = < 6 2 >;
> +       reg = < 0x40000000 0x10000 >;
> +       xlnx,all-inputs = <0x0>;
> +       xlnx,all-inputs-2 = <0x0>;
> +       xlnx,dout-default = <0x0>;
> +       xlnx,dout-default-2 = <0x0>;
> +       xlnx,gpio-width = <0x2>;
> +       xlnx,gpio2-width = <0x2>;
> +       xlnx,interrupt-present = <0x1>;
> +       xlnx,is-dual = <0x1>;

xlnx,is-dual;

I'm not giving up on this suggestion.

Test it please...

Yours,
Linus Walleij
