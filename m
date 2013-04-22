Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3DVObF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:31:05 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:50491 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3DVObC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:31:02 -0400
X-Auth-Info: mdqwaiv0GepmiLDBd+vZIphQlLjN3wpdt0D12j29CC8=
From: Marek Vasut <marex@denx.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH RESEND] video: mxsfb: Fix colors display on lower color depth
Date: Mon, 22 Apr 2013 16:30:48 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Brian Lilly <brian@crystalfontz.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1366618310-7068-1-git-send-email-maxime.ripard@free-electrons.com> <201304221116.18080.marex@denx.de> <51750EB9.3020301@free-electrons.com>
In-Reply-To: <51750EB9.3020301@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304221630.48644.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Maxime Ripard,

> Hi Marek,
> 
> Le 22/04/2013 11:16, Marek Vasut a écrit :
> > Dear Maxime Ripard,
> > 
> >> The current code always registers as a 32 bits display, and uses the
> >> hardware to drop the MSB of each color to abjust to the interface width
> >> used by the panel.
> >> 
> >> This results on 18 bits (and probably 16 bits display as well) in colors
> >> being displayed poorly, because the MSB are obviously the most important
> >> bits for each color definition.
> >> 
> >> The default controller behaviour when using an interface width smaller
> >> than the color depth is to drop the LSBs of each color, which makes more
> >> sense because you lose the least important part of the color definition.
> >> 
> >> So, to fix the colors display, just get back to the default controller
> >> behaviour.
> >> 
> >> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > 
> > Did you receive my latest email? Check M28EVK (imx28-m28evk.dts), it uses
> > 18bit LCD and works without this patch I think.
> 
> Thanks for the pointer. You mentionned in your other mail that it was
> wired on 24bits but that the screen is actually 18 bits. I went to
> search for the schematics to look at the wirings to see what could
> differ, but I couldn't find any for the M28EVK. Are they publicly
> available?

Yes, [1] page 6 .

[1] http://www.denx-cs.de/doku/sites/default/files/M28EVK_V20_0.pdf

Best regards,
Marek Vasut
