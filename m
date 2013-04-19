Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030726Ab3DSP0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:26:35 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:48868 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030512Ab3DSP0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <1366383906-25747-1-git-send-email-eric@eukrea.com>
References: <1366383906-25747-1-git-send-email-eric@eukrea.com>
Date: Fri, 19 Apr 2013 12:26:33 -0300
Message-ID: <CAOMZO5B9mL9rzYc9zHjJ_994u=HVerHGa+C+Lqc8VJmse8ak2Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: mx28: add dma channels for all auarts
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Fri, Apr 19, 2013 at 12:05 PM, Eric Bénard <eric@eukrea.com> wrote:
> Only auart0 was filled.
> Tested on a custom i.MX283 board for ttyAPP1/2/3/4.
>
> Signed-off-by: Eric Bénard <eric@eukrea.com>
> ---
>  arch/arm/boot/dts/imx28.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
> index 25f2243..15933ed 100644
> --- a/arch/arm/boot/dts/imx28.dtsi
> +++ b/arch/arm/boot/dts/imx28.dtsi
> @@ -886,6 +886,7 @@
>                                 compatible = "fsl,imx28-auart", "fsl,imx23-auart";
>                                 reg = <0x8006c000 0x2000>;
>                                 interrupts = <113 72 73>;
> +                               fsl,auart-dma-channel = <10 11>;

Now we use the generic 'dmas' binding to passing such information.

If you look at linux-next tree these UART dma channels are already
been passed via the new 'dmas' method:

			auart1: serial@8006c000 {
				compatible = "fsl,imx28-auart", "fsl,imx23-auart";
				reg = <0x8006c000 0x2000>;
				interrupts = <113 72 73>;
				dmas = <&dma_apbx 10>, <&dma_apbx 11>;
				dma-names = "rx", "tx";
				clocks = <&clks 45>;
				status = "disabled";
			};
