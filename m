Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab3DSQLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:11:49 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:53634 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3DSQLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:11:48 -0400
X-Greylist: delayed 3993 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Apr 2013 12:11:47 EDT
Date: Fri, 19 Apr 2013 18:11:34 +0200
From: Eric =?UTF-8?B?QsOpbmFyZA==?= <eric@eukrea.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] ARM: mx28: add dma channels for all auarts
Message-ID: <20130419181134.06eded8f@e6520eb>
In-Reply-To: <CAOMZO5B9mL9rzYc9zHjJ_994u=HVerHGa+C+Lqc8VJmse8ak2Q@mail.gmail.com>
References: <1366383906-25747-1-git-send-email-eric@eukrea.com>
	<CAOMZO5B9mL9rzYc9zHjJ_994u=HVerHGa+C+Lqc8VJmse8ak2Q@mail.gmail.com>
Organization: =?UTF-8?B?RXVrcsOpYQ==?= Electromatique
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

Le Fri, 19 Apr 2013 12:26:33 -0300,
Fabio Estevam <festevam@gmail.com> a écrit :
> On Fri, Apr 19, 2013 at 12:05 PM, Eric Bénard <eric@eukrea.com> wrote:
> > Only auart0 was filled.
> > Tested on a custom i.MX283 board for ttyAPP1/2/3/4.
> >
> > Signed-off-by: Eric Bénard <eric@eukrea.com>
> > ---
> >  arch/arm/boot/dts/imx28.dtsi | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
> > index 25f2243..15933ed 100644
> > --- a/arch/arm/boot/dts/imx28.dtsi
> > +++ b/arch/arm/boot/dts/imx28.dtsi
> > @@ -886,6 +886,7 @@
> >                                 compatible = "fsl,imx28-auart", "fsl,imx23-auart";
> >                                 reg = <0x8006c000 0x2000>;
> >                                 interrupts = <113 72 73>;
> > +                               fsl,auart-dma-channel = <10 11>;
> 
> Now we use the generic 'dmas' binding to passing such information.
> 
> If you look at linux-next tree these UART dma channels are already
> been passed via the new 'dmas' method:
> 
> 			auart1: serial@8006c000 {
> 				compatible = "fsl,imx28-auart", "fsl,imx23-auart";
> 				reg = <0x8006c000 0x2000>;
> 				interrupts = <113 72 73>;
> 				dmas = <&dma_apbx 10>, <&dma_apbx 11>;
> 				dma-names = "rx", "tx";
> 				clocks = <&clks 45>;
> 				status = "disabled";
> 			};

OK so forget my patch it was against 3.9-rc

Eric
