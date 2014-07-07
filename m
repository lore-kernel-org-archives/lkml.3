Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaGGTm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:42:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35061 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaGGTm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:42:27 -0400
Date: Mon, 7 Jul 2014 12:42:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.15.4 runs *significantly* slower than 3.15.3 on iMX233 CPU
Message-ID: <20140707194223.GA29819@roeck-us.net>
References: <lpeofi$1fl$1@ger.gmane.org>
 <20140707191430.GA23004@roeck-us.net>
 <lpeseg$lip$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lpeseg$lip$1@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 09:29:21PM +0200, Manuel Reimer wrote:
> On 07/07/2014 09:14 PM, Guenter Roeck wrote:
> >Are you sure this did not just happen when you booted the new kernel
> >for the first time ? I have seen similar behavior with some distributions.
> 
> I did some more tries and found out that I had disabled some of my
> patches until I reached 3.15.4 (latest version) where I decided to
> do needed modifications to get my patches back in.
> 
> I tracked the problem down to the following patch:
> 
> 
> diff --git a/arch/arm/boot/dts/imx23-olinuxino.dts
> b/arch/arm/boot/dts/imx23-olinuxino.dts
> index d107c4a..993da2e 100644
> --- a/arch/arm/boot/dts/imx23-olinuxino.dts
> +++ b/arch/arm/boot/dts/imx23-olinuxino.dts
> @@ -64,7 +64,14 @@
>  				compatible = "fsl,imx23-spi";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&spi2_pins_a>;
> +				clock-frequency = <1000000>;

If I understand the code correctly, that means you reduce the access speed
for SPI flashes from 160 MHz down to 1 MHz.

If so, and if your system loads anything from a SPI flash, I would not be too
surprised that your system is now a bit on the slow side.

Guenter
