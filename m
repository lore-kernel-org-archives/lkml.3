Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3DVJKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:10:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57030 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3DVJKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:10:41 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] video: mxsfb: Fix colors display on lower color depth
Date: Mon, 22 Apr 2013 11:08:16 +0200
User-Agent: KMail/1.9.10
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>, linux-fbdev@vger.kernel.org,
        Brian Lilly <brian@crystalfontz.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
References: <1366618310-7068-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1366618310-7068-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201304221108.17339.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.76
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Maxime Ripard wrote:
> The current code always registers as a 32 bits display, and uses the
> hardware to drop the MSB of each color to abjust to the interface width
> used by the panel.
>
> This results on 18 bits (and probably 16 bits display as well) in colors
> being displayed poorly, because the MSB are obviously the most important
> bits for each color definition.

But the "def_rgb666" bitfield description reports correctly to use bit 0..5 
for each colour component in this mode. Maybe your userland program has a bug 
and forgets to honor the bitfield description?

> The default controller behaviour when using an interface width smaller
> than the color depth is to drop the LSBs of each color, which makes more
> sense because you lose the least important part of the color definition.
>
> So, to fix the colors display, just get back to the default controller
> behaviour.

If you do this change, you also must adapt the "def_rgb666" bitfield 
description.
This structure currently reports the lower 6 bits to be used for this mode:
  blue -> 0..5 (skip 6/7)
  green -> 8..13 (skip 14/15)
  red -> 16..21 (skip 22/23).

> [...]

jbe

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
