Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3DVKQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:16:35 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:44697 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3DVKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:16:33 -0400
Message-ID: <51750DCB.3060306@free-electrons.com>
Date: Mon, 22 Apr 2013 12:15:39 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Juergen Beisert <jbe@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>, linux-fbdev@vger.kernel.org,
        Brian Lilly <brian@crystalfontz.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH RESEND] video: mxsfb: Fix colors display on lower color
 depth
References: <1366618310-7068-1-git-send-email-maxime.ripard@free-electrons.com> <201304221108.17339.jbe@pengutronix.de>
In-Reply-To: <201304221108.17339.jbe@pengutronix.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juergen,

Le 22/04/2013 11:08, Juergen Beisert a écrit :
> Hi Maxime,
> 
> Maxime Ripard wrote:
>> The current code always registers as a 32 bits display, and uses the
>> hardware to drop the MSB of each color to abjust to the interface width
>> used by the panel.
>>
>> This results on 18 bits (and probably 16 bits display as well) in colors
>> being displayed poorly, because the MSB are obviously the most important
>> bits for each color definition.
> 
> But the "def_rgb666" bitfield description reports correctly to use bit 0..5 
> for each colour component in this mode. Maybe your userland program has a bug 
> and forgets to honor the bitfield description?

Hmmm, that might be the case actually, yes, I'll check into this and let
you know. Thanks!

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
