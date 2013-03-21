Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3CUR70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:59:26 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61088 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3CUR7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:59:24 -0400
Message-ID: <514B4A79.1070501@gmail.com>
Date: Thu, 21 Mar 2013 12:59:21 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com> <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 11:26 AM, Gregory CLEMENT wrote:
> In order to be able to use more than 4GB of RAM when the LPAE is
> activated, the dts must be converted in 64 bits.
> 
> Armada XP and Armada 370 share a dtsi file which have also be
> converted to 64 bits. This lead to convert all the device tree files
> to 64 bits even the one used for Armada 370 (which don't support
> LPAE)
> 
> This was heavily based on the work of Lior Amsalem.
> 
> Signed-off-by: Lior Amsalem <alior@marvell.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

[snip]

> diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
> index 5b70820..562f24c 100644
> --- a/arch/arm/boot/dts/armada-370-xp.dtsi
> +++ b/arch/arm/boot/dts/armada-370-xp.dtsi
> @@ -15,8 +15,7 @@
>   * This file contains the definitions that are common to the Armada
>   * 370 and Armada XP SoC.
>   */
> -
> -/include/ "skeleton.dtsi"
> +/include/ "skeleton64.dtsi"
>  
>  / {
>  	model = "Marvell Armada 370 and XP SoC";
> @@ -37,20 +36,20 @@
>  
>  	coherency-fabric@d0020200 {
>  		compatible = "marvell,coherency-fabric";
> -		reg = <0xd0020200 0xb0>,
> -		      <0xd0021810 0x1c>;
> +		reg = <0 0xd0020200 0 0xb0>,
> +		      <0 0xd0021810 0 0x1c>;
>  	};
>  
>  	soc {
> -		#address-cells = <1>;
> -		#size-cells = <1>;
> +		#address-cells = <2>;
> +		#size-cells = <2>;

If all the addresses for the soc bus are below 4GB or even within a 4GB
range if using the ranges property, then changing all this and
everything below it is kind of pointless.

Rob

