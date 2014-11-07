Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaKGGmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:42:52 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38212 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaKGGmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:42:50 -0500
Message-ID: <545C69E7.6010909@gmail.com>
Date: Thu, 06 Nov 2014 22:42:47 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <545C694D.1030204@gmail.com>
In-Reply-To: <545C694D.1030204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2014 10:40 PM, Frank Rowand wrote:
> From: Frank Rowand <frank.rowand@sonymobile.com>
> 
> Update msm8974 dtsi for msm_serial to reflect msm_serial_probe()
> getting line id from the serial alias.
> 
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
> ---
>  arch/arm/boot/dts/qcom-msm8974.dtsi |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: b/arch/arm/boot/dts/qcom-msm8974.dtsi
> ===================================================================
> --- a/arch/arm/boot/dts/qcom-msm8974.dtsi
> +++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
> @@ -9,6 +9,10 @@
>  	compatible = "qcom,msm8974";
>  	interrupt-parent = <&intc>;
>  
> +	aliases {
> +		serial0 = &serial0;
> +	};
> +
>  	cpus {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> @@ -189,7 +193,7 @@
>  			reg = <0xfd8c0000 0x6000>;
>  		};
>  
> -		serial@f991e000 {
> +		serial0: serial@f991e000 {
>  			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
>  			reg = <0xf991e000 0x1000>;
>  			interrupts = <0 108 0x0>;
> 

This same change is also needed in:

  qcom-ipq8064.dtsi
  qcom-msm8960.dtsi
  qcom-apq8084.dtsi
  qcom-apq8064.dtsi
  qcom-msm8660.dtsi

but I did not want to just blindly apply those changes without testing.

-Frank
