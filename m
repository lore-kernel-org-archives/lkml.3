Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966048Ab3DROAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:00:32 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35226 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935635Ab3DROAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:00:30 -0400
X-Auth-Info: honeGJaXEFe0sy5kmzhi368njQyaTZvnqlfNy3Rr2co=
From: Marek Vasut <marex@denx.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] video: mxsfb: Fix colors display on lower color depth
Date: Thu, 18 Apr 2013 16:00:27 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Brian Lilly <brian@crystalfontz.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <516EBCA4.1020609@free-electrons.com> <1366277032-671-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1366277032-671-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181600.27813.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Maxime Ripard,

> The current code always registers as a 32 bits display, and uses the
> hardware to drop the MSB of each color to abjust to the interface width
> used by the panel.
> 
> This results on 18 bits (and probably 16 bits display as well) in colors
> being displayed poorly, because the MSB are obviously the most important
> bits for each color definition.
> 
> The default controller behaviour when using an interface width smaller
> than the color depth is to drop the LSBs of each color, which makes more
> sense because you lose the least important part of the color definition.
> 
> So, to fix the colors display, just get back to the default controller
> behaviour.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Isn't this what M28EVK is doing already? This was last tested on 3.9-rc3 I 
think:

bits-per-pixel = <16>;
bus-width = <18>;

But it's also true we have all 24 data lines routed to the LCD.

Best regards,
Marek Vasut
