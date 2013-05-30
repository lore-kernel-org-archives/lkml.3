Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab3E3JFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:05:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40000 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967252Ab3E3JFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:05:38 -0400
Message-ID: <51A71455.9000002@ti.com>
Date: Thu, 30 May 2013 14:26:53 +0530
From: keerthy <j-keerthy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 7/7] thermal: ti-soc-thermal: add DT example for DRA752
 chip
References: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com> <1369840066-20357-8-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1369840066-20357-8-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On 05/29/2013 08:37 PM, Eduardo Valentin wrote:

> Update documentation by adding an example for DRA752 on DT description.
> 
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: J Keerthy <j-keerthy@ti.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt b/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
> index 1629652..1953b33 100644
> --- a/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
> @@ -59,3 +59,15 @@ bandgap {
>  	compatible = "ti,omap5430-bandgap";
>  	interrupts = <0 126 4>; /* talert */
>  };
> +
> +DRA752:
> +bandgap {
> +	reg = <0x4a0021e0 0xc
> +		0x4a00232c 0xc
> +		0x4a002380 0x2c
> +		0x4a0023C0 0x3c
> +		0x4a002564 0x8
> +		0x4a002574 0x50>;
> +	compatible = "ti,dra752-bandgap";


The general convention seems to be keeping it as dra7xx or dra7.
Why add specific nodes like dra752? We can always reuse for
forthcoming dra7 processors if the same address mapping and IP
is retained right?

> +	interrupts = <0 126 4>; /* talert */


The TRM does not have any term called talert. Can the comment
be /* thermal_alert */ so it is easy to figure out what it is.

> +};


Regards,
Keerthy
