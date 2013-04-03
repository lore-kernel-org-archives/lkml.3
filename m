Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763074Ab3DCTH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:07:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60839 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab3DCTHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:07:55 -0400
Message-ID: <515C7E07.4040505@wwwdotorg.org>
Date: Wed, 03 Apr 2013 13:07:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] ARM: tegra: finalize USB EHCI and PHY bindings
References: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com> <1364978502-22887-2-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1364978502-22887-2-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 02:41 AM, Venu Byravarasu wrote:
> The existing Tegra USB bindings have a few issues:
...
> This patch fixes the binding definition to resolve these issues.

> diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt

>  Required properties :
...
> +  - vbus-supply: regulator for VBUS

Doesn't the driver only need to control VBUS if the port is in OTG mode?

If there is no VBUS control, and the HW provides VBUS, I think that the
port can only operate in host mode.

If there is no VBUS control, and the HW does not provide VBUS, I think
that the port can only operate in peripheral mode.

If there is VBUS control, then shouldn't the port always operate in OTG
mode, or are there other reasons to control VBUS even in host-only mode?

If VBUS control is only useful for OTG mode, then I think the
vbus-supply property should be documented in a "Required properties for
dr_mode == otg" section.

I assume that VBUS control makes no sense for a peripheral-mode-only
port, so if VBUS control is useful for host-only mode as well as OTG
mode, then I think the vbus-supply property should be documented in a
"Required properties for dr_mode != peripheral" section.

Is the following table correct?

Port operating mode:	host	peripheral	otg
--------------------	----	----------	---
VBUS control required:	no	no		yes
VBUS control useful:	yes[1]?	no		yes

[1] perhaps for power-saving/suspend???
