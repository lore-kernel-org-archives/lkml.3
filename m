Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbbAMUGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:06:48 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63826 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbAMUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:06:46 -0500
MIME-Version: 1.0
In-Reply-To: <1420924457-12730-1-git-send-email-linus.walleij@linaro.org>
References: <1420924457-12730-1-git-send-email-linus.walleij@linaro.org>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 13 Jan 2015 14:06:24 -0600
Message-ID: <CAL_JsqKQJzUOWE2oJsABH3Aa1cCD+526L0G7-WRH=LbKFxesyQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: fix up device tree bindings
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 3:14 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> After the Nomadik pin controller was force migrated to generic pin
> control bindings, some leftovers in the documentation need to be
> cleaned up. The code and device trees are already migrated.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied for 3.20. Thanks.

> ---
>  .../devicetree/bindings/pinctrl/ste,nomadik.txt    | 35 ++++++++++++----------
>  1 file changed, 20 insertions(+), 15 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> index 6b33b9f18e88..f63fcb3ed352 100644
> --- a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
> @@ -16,17 +16,22 @@ mux function to select on those pin(s)/group(s), and various pin configuration
>  parameters, such as input, output, pull up, pull down...
>
>  The name of each subnode is not important; all subnodes should be enumerated
> -and processed purely based on their content.
> +and processed purely based on their content. The subnodes use the generic
> +pin multiplexing node layout from the standard pin control bindings
> +(see pinctrl-bindings.txt):
>
> -Required subnode-properties:
> -- ste,pins : An array of strings. Each string contains the name of a pin or
> -    group.
> -
> -Optional subnode-properties:
> -- ste,function: A string containing the name of the function to mux to the
> +Required pin multiplexing subnode properties:
> +- function: A string containing the name of the function to mux to the
>    pin or group.
> +- groups : An array of strings. Each string contains the name of a pin
> +  group that will be combined with the function to form a multiplexing
> +  set-up.
>
> -- ste,config: Handle of pin configuration node (e.g. ste,config = <&slpm_in_wkup_pdis>)
> +Required pin configuration subnode properties:
> +- pins: A string array describing the pins affected by the configuration
> +  in the node.
> +- ste,config: Handle of pin configuration node
> +  (e.g. ste,config = <&slpm_in_wkup_pdis>)
>
>  - ste,input : <0/1/2>
>         0: input with no pull
> @@ -97,32 +102,32 @@ Example board file extract:
>                 uart0 {
>                         uart0_default_mux: uart0_mux {
>                                 u0_default_mux {
> -                                       ste,function = "u0";
> -                                       ste,pins = "u0_a_1";
> +                                       function = "u0";
> +                                       pins = "u0_a_1";
>                                 };
>                         };
>                         uart0_default_mode: uart0_default {
>                                 uart0_default_cfg1 {
> -                                       ste,pins = "GPIO0", "GPIO2";
> +                                       pins = "GPIO0", "GPIO2";
>                                         ste,input = <1>;
>                                 };
>
>                                 uart0_default_cfg2 {
> -                                       ste,pins = "GPIO1", "GPIO3";
> +                                       pins = "GPIO1", "GPIO3";
>                                         ste,output = <1>;
>                                 };
>                         };
>                         uart0_sleep_mode: uart0_sleep {
>                                 uart0_sleep_cfg1 {
> -                                       ste,pins = "GPIO0", "GPIO2";
> +                                       pins = "GPIO0", "GPIO2";
>                                         ste,config = <&slpm_in_wkup_pdis>;
>                                 };
>                                 uart0_sleep_cfg2 {
> -                                       ste,pins = "GPIO1";
> +                                       pins = "GPIO1";
>                                         ste,config = <&slpm_out_hi_wkup_pdis>;
>                                 };
>                                 uart0_sleep_cfg3 {
> -                                       ste,pins = "GPIO3";
> +                                       pins = "GPIO3";
>                                         ste,config = <&slpm_out_wkup_pdis>;
>                                 };
>                         };
> --
> 1.9.3
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
