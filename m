Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3IWUuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:50:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39503 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3IWUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:50:51 -0400
Message-ID: <5240A9A7.8080307@wwwdotorg.org>
Date: Mon, 23 Sep 2013 14:50:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: lee.jones@linaro.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, broonie@kernel.org
Subject: Re: [PATCH] mfd: core: introduce of_node_name for mfd sub devices
References: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 02:29 AM, Laxman Dewangan wrote:

> diff --git a/Documentation/devicetree/bindings/mfd/mfd-core.txt b/Documentation/devicetree/bindings/mfd/mfd-core.txt

> +MFD DT binding document
> +-----------------------
> +
> +Multi Function Devices (MFDs) have multiple sub module whose driver is developed
> +in different sub-system like GPIO, regulators, RTC, clock etc. The device
> +tree of such device contains multiple sub-node which contains the properties
> +of these sub-modules.
> +The sub modules get of_node handle either by the dev->of_node or by getting
> +the child node handle from parent DT handle by finding child name on parent's
> +of_node.
> +To provide the of_node of sub-module directly, there is two approach:
> +- Add compatible value when defining the sub-module in mfd core and
> +  add this properties when adding DT.
> +- Add the of_node_name when defining the sub-module in mfd core and
> +  add keep same name of child node when adding DT.
> +
> +If none of above matches then sub-module driver will not get their of_node
> +and they need to derive the method to get their node from parent node.

That's all *far* too specific to Linux's internals for a DT binding
document.

I think it's fine for DT bindings for aggregate devices to be written to
require a separate node (with a specific name) for various
sub-components of the HW, if it makes sense to do so from a purely DT
binding perspective. However, the fact that some DT bindings might be
written that way implies nothing about any other particular DT binding,
nor about all other DT bindings.

And indeed if you find that there are a bunch of DT bindings that share
this structure, by all means create some common code to simplify the
drivers for those bindings. However, that still doesn't mean that every
driver or binding has to be structured like that.
