Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaDZJog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 05:44:36 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62627 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaDZJod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 05:44:33 -0400
Message-ID: <535B7FFC.3000109@gmail.com>
Date: Sat, 26 Apr 2014 11:44:28 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        linus.walleij@linaro.org
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] Documentation: add the Marvell Berlin pinctrl
 documentation
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com> <1398268276-9696-7-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1398268276-9696-7-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 05:51 PM, Antoine Ténart wrote:
> Add the documentation related to the Berlin pin-controller driver and
> explain how to configure this group based controller.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  .../bindings/pinctrl/marvell,berlin-pinctrl.txt    | 44 ++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
> new file mode 100644
> index 000000000000..c59671ac6b54
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
> @@ -0,0 +1,44 @@
> +* Pin-controller driver for the Marvell Berlin SoCs
> +
> +The pins controlled by the Marvell Berlin controller are organized in groups.
> +Configuration is done by group, so no actual pin information is needed.
> +
> +Be aware the Marvell Berlin datasheets use the keyword 'mode' for what is called
> +a 'function' in the pin-controller subsystem.
> +
> +Required properties:
> +- compatible: should be one of: "marvell,berlin2-soc-pinctrl",

nit: add the line break right after "one of:".

> +				"marvell,berlin2-sysmgr-pinctrl",
> +				"marvell,berlin2cd-soc-pinctrl",
> +				"marvell,berlin2cd-sysmgr-pinctrl",
> +				"marvell,berlin2q-soc-pinctrl"
> +				"marvell,berlin2q-sysmgr-pinctrl"
> +- reg: registers physical address and length of the pin controller.
> +
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pin-controller bindings used by client devices.
> +
> +A pin-controller node should contain subnodes representing the pin group
> +configurations, one per group. Each subnode has the group name and the muxing

",one per group" isn't correct, is it? You can have one subnode with
more than one group, like in your example below.

Sebastian

> +function used.
> +
> +Required subnode-properties:
> +- marvell,groups: a list of strings describing the group names.
> +- marvell,function: a string describing the function used to mux the groups.
> +
> +Example:
> +
> +sm_pinctrl: pin-controller@0 {
> +	compatible = "marvell,berlin2q-sysmgr-pinctrl";
> +	reg = <0xfc0000 0x44>;
> +
> +	uart0_pmux: uart0-pmux {
> +		marvell,groups = "GSM12", "GSM13";
> +		marvell,function = "uart0";
> +	};
> +}
> +
> +&uart0 {
> +	pinctrl-0 = <&uart0_pmux>;
> +	pinctrl-names = "default";
> +};
> 

