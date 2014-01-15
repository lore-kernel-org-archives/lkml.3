Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaAOJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:58:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57932 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaAOJ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:58:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [RFC PATCH V2 3/4] dt-bindings: pci: xgene pcie device tree bindings
Date: Wed, 15 Jan 2014 10:57:42 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@apm.com, jcm@redhat.com
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com> <1389742458-7693-4-git-send-email-tinamdar@apm.com>
In-Reply-To: <1389742458-7693-4-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401151057.43044.arnd@arndb.de>
X-Provags-ID: V02:K0:ZQZo5kTmNBrSZXRvBz3SMToBDCu2XTtdIN986pwJ1az
 eYZ7lTkXBxjASfRr6fYXQg9jAlzZPIofzKjy0gvJ5m26WxyQ8w
 dRGbROqn7pMABG0aJ9V2cPsnHb9pG4rUZEl8h5ZDzsTbcpI33p
 BguR17wki8+oCErPyZ9EI+EcIey2hfAC7CYGd2af1J4MBpvhJC
 XPEEsgfqHwIm3I7KQM/gQCCfCtQ3NPpubSrzXzs4VpQwg2q9nE
 SAR5mMrBDUKLkS78vG1nFXY+ZIqHUiqJq52utoHzz+3yBzYWw3
 WT/6CDrvUiABoWsgWFEN76bs1K5hw02fdoIbk5+OlW8NT73qaD
 sTokTWSAe5JVRyHhWbnw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014, Tanmay Inamdar wrote:
> This patch adds the bindings for X-Gene PCIe driver. The driver resides
> under 'drivers/pci/host/pci-xgene.c' file.
> 
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  .../devicetree/bindings/pci/xgene-pcie.txt         |   45 ++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/xgene-pcie.txt
> 
> diff --git a/Documentation/devicetree/bindings/pci/xgene-pcie.txt b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
> new file mode 100644
> index 0000000..19b9c28
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
> @@ -0,0 +1,45 @@
> +* AppliedMicro X-Gene PCIe interface
> +
> +Required properties:
> +- status: Either "ok" or "disabled".

"status" isn't normally a required property. The default interpretation is
that a node without a status property is active.

> +- device_type: set to "pci"
> +- compatible: should contain "xgene,pcie" to identify the core.
> +- reg: base addresses and lengths of the pcie controller configuration
> +	space register.

Doesn't match the code or example: You only list one area here, but
you actually need to register sets.

Looks good otherwise now.

	Arnd
