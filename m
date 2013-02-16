Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3BPXMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 18:12:44 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:61148 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab3BPXMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 18:12:43 -0500
Date: Sat, 16 Feb 2013 14:38:05 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 1/3] power_supply: Define Binding for supplied-nodes
Message-ID: <20130216223804.GF1741@lizard.sbx05280.losalca.wayport.net>
References: <1360971416-30717-1-git-send-email-rklein@nvidia.com>
 <1360971416-30717-2-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360971416-30717-2-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 06:36:54PM -0500, Rhyland Klein wrote:
> This property is meant to be used in device nodes which represent
> power_supply devices that wish to provide a list of supplies to
> which they provide power. A common case is a AC Charger with
> the batteries it powers.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  .../bindings/power_supply/power_supply.txt         |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/power_supply.txt
> 
> diff --git a/Documentation/devicetree/bindings/power_supply/power_supply.txt b/Documentation/devicetree/bindings/power_supply/power_supply.txt
> new file mode 100644
> index 0000000..1c58d4ff
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/power_supply.txt
> @@ -0,0 +1,17 @@
> +Power Supply Core Support
> +
> +Optional Properties:
> + - power-supply,supplied-nodes : This property is added to a supply
> +   in order to specify the list of supplicant devices directly by their
> +   phandles.

"supplied nodes" sounds confusing (doesn't reflect direction), IMO. I'd
rather call it power-supply,supplied-to = <&some_battery>;

But... I'm recalling there was a similar discussion not that long ago, and
Arnd came up with the idea that supplied-to is not fully in spirit of DT,
and proposed his view of proper bindings. Please find the discussion here:

  http://lkml.org/lkml/2012/9/14/104

Thanks,

Anton

> +
> +Example:
> +
> +	charger@e {
> +		compatible = "some,charger";
> +		...
> +
> +		power-supply,supplied-nodes = <&some_battery>,
> +					      <&another_battery>;
> +		...
> +	};
> -- 
> 1.7.9.5
