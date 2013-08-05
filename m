Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3HEVmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 17:42:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40550 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3HEVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 17:42:48 -0400
Message-ID: <52001C54.7020908@wwwdotorg.org>
Date: Mon, 05 Aug 2013 15:42:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, ian.campbell@citrix.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, grant.likely@linaro.org,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gg@slimlogic.co.uk, kishon@ti.com
Subject: Re: [PATCH V2 2/3] pinctrl: pinconf-generic: add generic APIs for
 mapping pinctrl node
References: <1375688014-6117-1-git-send-email-ldewangan@nvidia.com> <1375688014-6117-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1375688014-6117-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 01:33 AM, Laxman Dewangan wrote:
> Add generic APIs to map the DT node and its sub node in pinconf generic
> driver. These APIs can be used from driver to parse the DT node who

> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> index aeb3c99..52fb521 100644
> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> @@ -174,3 +174,19 @@ All parameters not listed here, do not take an argument.
>  
>  More in-depth documentation on these parameters can be found in
>  <include/linux/pinctrl/pinconfig-generic.h>
> +
> +Generic pinconfig option also support the defining of pins and functions.
> +The properties are:
> +pinctrl-pins: This property tells the name of pins or list of pins for which
> +  configuration is needed. The valid pin names are device/chip specific and
> +  it can be found from the device/chip specific binding documents.
> +pinctrl-function: This property tells the configuration of the pins on to the
> +  given function. The valid functions are device/chip specific and it can be
> +  found from the device/chip specific binding documents.

This text feels like it's just been bolted on the end rather than
integrated into the existing description of generic pinconfig options.
Also, the existing text for generic pinconfig options doesn't feel at
all right to me. I'll send a patch to clean that up, and integrate these
new properties.

I would name the new properties just pins and functions, given their
scope is explicitly limited to pinctrl configuration nodes, so
"pinctrl-" is a little redundant.

With the properties renamed, and this patch rebased on top of the patch
I'll send out later, this patch,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
