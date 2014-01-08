Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaAHKGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:06:22 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44515 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755262AbaAHKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:06:20 -0500
Date: Wed, 8 Jan 2014 10:05:50 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Feng Kan <fkan@apm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2 1/6] Documentation: add dts binding for X-Gene
 reboot dts node.
Message-ID: <20140108100549.GE6701@e106331-lin.cambridge.arm.com>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
 <1389135041-16062-2-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389135041-16062-2-git-send-email-fkan@apm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 10:50:36PM +0000, Feng Kan wrote:
> Add X-Gene reboot device tree node documentation.
> 
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  .../devicetree/bindings/arm64/xgene/reboot.txt     |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm64/xgene/reboot.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm64/xgene/reboot.txt b/Documentation/devicetree/bindings/arm64/xgene/reboot.txt
> new file mode 100644
> index 0000000..51d23c1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm64/xgene/reboot.txt
> @@ -0,0 +1,10 @@
> +Reboot property to control system reboot on storm platforms:
> +
> +The register attribute contain the address of the reset register.

Required properties:

- compatible: should contain "apm,xgene-reboot"

- reg: the base address and size of the reset register.

> +
> +Example:
> +
> +	reboot@0 {
> +		compatible = "apm,xgene-reboot";
> +		reg = <0x0 0x17000014 0x0 0x4>;
> +	};

Given this seems to be a 64-bit address, the unit address should
preferably be 0,17000014 rather than just 0.

Thanks,
Mark.
