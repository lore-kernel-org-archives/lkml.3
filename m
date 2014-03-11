Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaCKIw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:52:58 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:56943
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbaCKIwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:52:51 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371Ie0eah1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h19b6n1155h)
Date: Tue, 11 Mar 2014 09:52:35 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 7/7] ARM: zynq: DT: Migrate UART to Cadence binding
References: <1394487610-2419-1-git-send-email-soren.brinkmann@xilinx.com> <1394487610-2419-8-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1394487610-2419-8-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <62cd32ad-8743-4d49-a1b6-c178054a9756@CO9EHSMHS011.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 10:40 PM, Soren Brinkmann wrote:
> The Zynq UART is Cadence IP and the driver has been renamed accordingly.
> Migrate the DT to use the new binding for the UART driver.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
> This change depends on 'tty: xuartps: Rebrand driver as Cadence UART',
> which introduces the new clock-names.
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 8b67b19392ec..0ed0d4b0579a 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -67,19 +67,19 @@
>  		};
>  
>  		uart0: uart@e0000000 {
> -			compatible = "xlnx,xuartps";
> +			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
>  			status = "disabled";
>  			clocks = <&clkc 23>, <&clkc 40>;
> -			clock-names = "ref_clk", "aper_clk";
> +			clock-names = "uart_clk", "pclk";
>  			reg = <0xE0000000 0x1000>;
>  			interrupts = <0 27 4>;
>  		};
>  
>  		uart1: uart@e0001000 {
> -			compatible = "xlnx,xuartps";
> +			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
>  			status = "disabled";
>  			clocks = <&clkc 24>, <&clkc 41>;
> -			clock-names = "ref_clk", "aper_clk";
> +			clock-names = "uart_clk", "pclk";
>  			reg = <0xE0001000 0x1000>;
>  			interrupts = <0 50 4>;
>  		};

This should be at least the part of 5/7 because between 5/7 and 7/7
driver will fail to probe.

Thanks,
Michal


