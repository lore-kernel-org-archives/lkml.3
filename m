Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaKKPAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:00:19 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:56740 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaKKPAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:00:16 -0500
MIME-Version: 1.0
In-Reply-To: <1415041531-15520-5-git-send-email-soren.brinkmann@xilinx.com>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
	<1415041531-15520-5-git-send-email-soren.brinkmann@xilinx.com>
Date: Tue, 11 Nov 2014 16:00:15 +0100
Message-ID: <CACRpkdazagbSZdMvHTggQuAFm9uObn2ARoCwcyM-sspuLTXqkQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] pinctrl: zynq: Document DT binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Add documentation for the devicetree binding for the Zynq pincontroller.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
(...)
> +Example:
> +       pinctrl0: pinctrl@700 {
> +               compatible = "xlnx,pinctrl-zynq";
> +               reg = <0x700 0x200>;
> +               syscon = <&slcr>;
> +
> +               pinctrl_uart1_default: pinctrl-uart1-default {
> +                       common {
> +                               groups = "uart1_10_grp";
> +                               function = "uart1";
> +                               slew-rate = <0>;
> +                               io-standard = <1>;
> +                       };

I don't really like that you mix multiplexing and config in the
same node. I would prefer if the generic bindings say we have
muxing nodes and config nodes, and those are disparate.

Can't you just split this:

common-mux {
    groups = "uart1_10_grp";
    function = "uart1";
};

common-config {
    groups = "uart1_10_grp";
    slew-rate = <0>;
    io-standard = <1>;
};

That way we can identify nodes as mux nodes (have "function")
or config nodes (have "groups" or "pins" but not "function") which
I think makes things easier to read.

Yours,
Linus Walleij
