Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3DCTdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:33:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53007 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab3DCTdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:33:23 -0400
Message-ID: <515C83FF.10004@wwwdotorg.org>
Date: Wed, 03 Apr 2013 13:33:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] ARM: tegra: update device trees for USB binding
 rework
References: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com> <1364978502-22887-3-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1364978502-22887-3-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 02:41 AM, Venu Byravarasu wrote:
> This patch updates all Tegra board files so that they contain all the
> properties required by the updated USB DT binding. Note that this patch
> only adds the new properties and does not yet remove the old properties,
> in order to maintain bisectability. The old properties will be removed
> once the driver has been updated to assume the new bindings.

> diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> index cb73e62..af5a7ae 100644
> --- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> +++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> @@ -443,6 +443,10 @@
>  		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */

Another problem here: The code pulses this GPIO low to reset the PHY, so
in other words, the GPIO is active low.

Can you please prepare a separate patch to fix this; you need to change
all existing instances from:

nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */

to:

nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1, active low */

Insert that new patch before this patch in the series, and then fix this
patch so that any new copies of that property have the correct content
from the start.

Note: I pointed out this problem in my review of V1, but V2 didn't
include a fix for it:-(
