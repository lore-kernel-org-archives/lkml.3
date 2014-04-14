Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaDNNHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:07:13 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38792 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754956AbaDNNHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:07:02 -0400
Message-ID: <534BDD6F.2070903@codethink.co.uk>
Date: Mon, 14 Apr 2014 14:06:55 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Iyappan Subramanian <isubramanian@apm.com>, davem@davemloft.net,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH v2 2/4] Documentation: dts: Add bindings for APM X-Gene
 SoC ethernet driver
References: <1397271984-23405-1-git-send-email-isubramanian@apm.com> <1397271984-23405-3-git-send-email-isubramanian@apm.com>
In-Reply-To: <1397271984-23405-3-git-send-email-isubramanian@apm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/14 04:06, Iyappan Subramanian wrote:
> This patch adds documentation for APM X-Gene SoC ethernet DTS binding.
>
> Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
> Signed-off-by: Ravi Patel <rapatel@apm.com>
> Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
> ---
>   .../devicetree/bindings/net/apm-xgene-enet.txt     |   46 ++++++++++++++++++++
>   1 file changed, 46 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/net/apm-xgene-enet.txt
>
> diff --git a/Documentation/devicetree/bindings/net/apm-xgene-enet.txt b/Documentation/devicetree/bindings/net/apm-xgene-enet.txt
> new file mode 100644
> index 0000000..0c983e8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/apm-xgene-enet.txt
> @@ -0,0 +1,46 @@
> +APM X-Gene SoC Ethernet nodes
> +
> +Ethernet nodes are defined to describe on-chip ethernet interfaces in
> +APM X-Gene SoC.
> +
> +Required properties:
> +- compatible		: Should be "apm,xgene-enet"
> +- reg			: First resource is the ethernet base register set
> +			  Second resource is the ring base register set
> +			  Third resource is the ring command register set
> +- interrupts		: Ethernet main interrupt
> +- clocks		: Reference to the clock entry.
> +- local-mac-address	: Ethernet MAC address.
> +- phy-addr		: Ethernet MII phy address.
> +- phy-mode		: Ethernet MII mode.
> +
> +Optional properties:
> +- status		: Should be "ok" or "disabled" for enabled/disabled.
> +			  Default is "ok".
> +
> +Example:
> +	menetclk: menetclk {
> +		compatible = "apm,xgene-device-clock";
> +		clock-output-names = "menetclk";
> +		status = "ok";
> +	};
> +
> +	menet: ethernet@17020000 {
> +		compatible = "apm,xgene-enet";
> +		status = "disabled";
> +		reg = <0x0 0x17020000 0x0 0xd100>,
> +		      <0x0 0X17030000 0x0 0X400>,
> +		      <0x0 0X10000000 0x0 0X200>;
> +		interrupts = <0x0 0x3c 0x4>;
> +		clocks = <&menetclk 0>;
> +		local-mac-address = [00 01 73 00 00 01];
> +		phy-addr = <3>;
> +		phy-mode = "rgmii";
> +	};

That doesn't look correct for a phy binding.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
