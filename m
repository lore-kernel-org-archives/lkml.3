Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbbAIPre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:47:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbbAIPrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:47:31 -0500
Message-ID: <54AFF7E3.4070506@redhat.com>
Date: Fri, 09 Jan 2015 16:46:43 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: =?windows-1252?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Documentation: bindings: Add the regulator property
 to the sub-nodes AHCI bindings
References: <1420799989-10645-1-git-send-email-gregory.clement@free-electrons.com> <1420799989-10645-3-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1420799989-10645-3-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09-01-15 11:39, Gregory CLEMENT wrote:
> It is now possible to use a regulator property for each port of the
> AHCI controller.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>   Documentation/devicetree/bindings/ata/ahci-platform.txt | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> index 4ab09f2202d4..87416d71c758 100644
> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> @@ -37,9 +37,10 @@ Required properties when using sub-nodes:
>
>
>   Sub-nodes required properties:
> -- reg               : the port number
> -- phys              : reference to the SATA PHY node
> -
> +- reg					: the port number
> +And at least one of the following properties:
> +- phys              	: reference to the SATA PHY node
> +- target-port<n>-supply	: regulator for SATA target power for port <n>
>
>   Examples:
>           sata@ffe08000 {
> @@ -68,10 +69,12 @@ With sub-nodes:
>   		sata0: sata-port@0 {
>   			reg = <0>;
>   			phys = <&sata_phy 0>;
> +			target-port0-supply = <&reg_sata0>;
>   		};
>

I'm sorry, but I've to NAK this, I did not follow the regulator discussion.,
thinking that it was just about the use of some utility function vs diy or
some such, I had no idea this would impact the dt-binding.

The -port%d- bit is completely unnecessary from a dt pov. Devicetree is
supposed to be OS agnostic, we cannot make the dt-binding ugly just because
the regulator subsys in Linux does not provide the necessary functionality.

I'm afraid you will have to get back to the regulator subsys people and tell
them that we really need an of_regulator_get, so that we can tell the
regulator subsys we want a regulator from a specific of_node.

Please CC me when you re-open the discussion with the regulator people.

Regards,

Hans
