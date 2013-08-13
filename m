Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab3HMT5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:57:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45199 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848Ab3HMT5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:57:34 -0400
Message-ID: <520A8FA9.2080603@wwwdotorg.org>
Date: Tue, 13 Aug 2013 13:57:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: balbi@ti.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/3] usb: dwc3: msm: Add device tree binding information
References: <1376042027-9798-1-git-send-email-iivanov@mm-sol.com> <1376042027-9798-2-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1376042027-9798-2-git-send-email-iivanov@mm-sol.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 03:53 AM, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> MSM USB3.0 core wrapper consist of USB3.0 IP (SNPS)
> and HS, SS PHY's controll and configuration registers.

s/controll/control/

> It could operate in device mode (SS, HS, FS) and host
> mode (SS, HS, FS, LS).

> diff --git a/Documentation/devicetree/bindings/usb/msm-ssusb.txt b/Documentation/devicetree/bindings/usb/msm-ssusb.txt

> +MSM SuperSpeed DWC3 USB SoC controller
> +
> +Required properities :
> +- compatible : sould be "qcom,dwc3-hsphy";
...
> +Required properities :
> +- compatible : sould be "qcom,dwc3-ssphy";

I would expect different compatible values to be documented in different
files.

> +Optional properties :
> +- gdsc-supply : phandle to the globally distributed switch controller
> +  regulator node to the USB controller.

Which of the 3 compatible values that were described above is that
property optional for?

> +Sub nodes:
> +- Sub node for "DWC3 USB3 controller".
> +  This sub node is required property for device node. The properties
> +  of this subnode are specified in dwc3.txt.

Why not represent the PHY and USB controller as separate top-level
nodes? They can point at each-other with phandles if they need to know
each-others' identity.
