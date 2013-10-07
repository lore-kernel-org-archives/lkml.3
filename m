Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3JGIRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 04:17:21 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:60916 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3JGIRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 04:17:19 -0400
Message-ID: <21074.28159.130293.169699@ipc1.ka-ro>
Date: Mon, 7 Oct 2013 10:17:03 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "kernel\@pengutronix.de" <kernel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH|RFC] of: let of_match_device() always return best match
In-Reply-To: <525052F5.5080204@pengutronix.de>
References: <1380826284-18381-1-git-send-email-mkl@pengutronix.de>
	<CAOMZO5BekS_BvJzrt8vM1=7LjsiO=3hKL=mMfTjxkO3aZ4qwRQ@mail.gmail.com>
	<525052F5.5080204@pengutronix.de>
X-Mailer: VM 8.1.0 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Marc Kleine-Budde writes:
> On 10/05/2013 07:46 PM, Fabio Estevam wrote:
> > Hi Marc,
> > 
> > On Thu, Oct 3, 2013 at 3:51 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > 
> >> For example:
> >>
> >> The imx28.dtsi gives this compatible string for its CAN core:
> >>
> >>>       compatible = "fsl,imx28-flexcan", "fsl,p1010-flexcan";
> >>
> >> The flexcan driver defines:
> >>
> >>> static const struct of_device_id flexcan_of_match[] = {
> >>>       { .compatible = "fsl,p1010-flexcan", .data = &fsl_p1010_devtype_data, },
> >>>       { .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
> >>>       { .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
> >>>       { /* sentinel */ },
> >>> };
> >>
> >> The "p1010" was the first Freescale SoC with the flexcan core. But this SoC has
> >> a bug, so a workaround has to be enabled in the driver. The mx28 has this bug
> >> fixed, so we don't need this quite costly workaround.
> > 
> > What about defining in imx28.dtsi:
> > compatible = "fsl,imx28-flexcan".
> 
> It already works with changing only the driver.
> 
IMO the change proposed by Fabio is much more sensible. If the imx28
implementation of the CAN controller is not compatible to p1010 (which
is obviously true) there is no point in having the "fsl,p1010-flexcan"
in the DT for imx28.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
