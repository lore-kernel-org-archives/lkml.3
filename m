Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaGOFek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 01:34:40 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50839 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaGOFei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 01:34:38 -0400
Message-ID: <53C4BD24.9000503@gmail.com>
Date: Tue, 15 Jul 2014 11:03:24 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, broonie@kernel.org,
        mark.rutland@arm.com
CC: robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv6 2/2] dt/bindings: Add the DT binding documentation for
 endianness
References: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com> <1405398183-31345-3-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1405398183-31345-3-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 09:53 AM, Xiubo Li wrote:
> Device-Tree binding for device endianness
> Index     Device     Endianness properties
> ---------------------------------------------------
> 1         BE         'big-endian'
> 2         LE         'little-endian'
>
> For one device driver, which will run in different scenarios above
> on different SoCs using the devicetree, we need one way to simplify
> this.
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>   .../devicetree/bindings/regmap/regmap.txt          | 47 ++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt
>
> diff --git a/Documentation/devicetree/bindings/regmap/regmap.txt b/Documentation/devicetree/bindings/regmap/regmap.txt
> new file mode 100644
> index 0000000..b494f8b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regmap/regmap.txt
> @@ -0,0 +1,47 @@
> +Device-Tree binding for regmap
> +
> +The endianness mode of CPU & Device scenarios:
> +Index     Device     Endianness properties
> +---------------------------------------------------
> +1         BE         'big-endian'
> +2         LE         'little-endian'
> +
> +For one device driver, which will run in different scenarios above
> +on different SoCs using the devicetree, we need one way to simplify
> +this.
> +
> +Required properties:
> +- {big,little}-endian: these are boolean properties, if absent
> +  meaning that the CPU and the Device are in the same endianness mode,
> +  these properties are for register values and all the buffers only.
> +

It would be more readable if its like this:
Required properties:
- {big,little}-endian:	These are boolean properties, if absent meaning
			that the CPU and the Device are in the same
			endianness mode, these propperties are for
			values and all the buffers only.

> +Examples:
> +Scenario 1 : CPU in LE mode & device in LE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +};
> +
> +Scenario 2 : CPU in LE mode & device in BE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      big-endian;
> +};
> +
> +Scenario 3 : CPU in BE mode & device in BE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +};
> +
> +Scenario 4 : CPU in BE mode & device in LE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      little-endian;
> +};


-- 
Regards,
Varka Bhadram.

