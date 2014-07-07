Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaGGT3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:29:36 -0400
Received: from plane.gmane.org ([80.91.229.3]:45127 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaGGT3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:29:35 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: 3.15.4 runs *significantly* slower than 3.15.3 on iMX233 CPU
Date: Mon, 07 Jul 2014 21:29:21 +0200
Message-ID: <lpeseg$lip$1@ger.gmane.org>
References: <lpeofi$1fl$1@ger.gmane.org> <20140707191430.GA23004@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5dd560e1.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
In-Reply-To: <20140707191430.GA23004@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 09:14 PM, Guenter Roeck wrote:
> Are you sure this did not just happen when you booted the new kernel
> for the first time ? I have seen similar behavior with some distributions.

I did some more tries and found out that I had disabled some of my 
patches until I reached 3.15.4 (latest version) where I decided to do 
needed modifications to get my patches back in.

I tracked the problem down to the following patch:


diff --git a/arch/arm/boot/dts/imx23-olinuxino.dts 
b/arch/arm/boot/dts/imx23-olinuxino.dts
index d107c4a..993da2e 100644
--- a/arch/arm/boot/dts/imx23-olinuxino.dts
+++ b/arch/arm/boot/dts/imx23-olinuxino.dts
@@ -64,7 +64,14 @@
  				compatible = "fsl,imx23-spi";
  				pinctrl-names = "default";
  				pinctrl-0 = <&spi2_pins_a>;
+				clock-frequency = <1000000>;
  				status = "okay";
+
+				spidev0: spidev@0 {
+					compatible = "spidev";
+					spi-max-frequency = <1000000>;
+					reg = <0>;
+				};
  			};
  		};


I need this to add spidev support. But I don't understand why this 
change kills performance? Maybe the "high" value in "clock-frequency"? 
Can someone give me some information on how to fix this?

Thank you very much in advance.

Greetings,

Manuel

