Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3DVKUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:20:42 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:44745 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3DVKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:20:39 -0400
Message-ID: <51750EB9.3020301@free-electrons.com>
Date: Mon, 22 Apr 2013 12:19:37 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Brian Lilly <brian@crystalfontz.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] video: mxsfb: Fix colors display on lower color
 depth
References: <1366618310-7068-1-git-send-email-maxime.ripard@free-electrons.com> <201304221116.18080.marex@denx.de>
In-Reply-To: <201304221116.18080.marex@denx.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

Le 22/04/2013 11:16, Marek Vasut a écrit :
> Dear Maxime Ripard,
> 
>> The current code always registers as a 32 bits display, and uses the
>> hardware to drop the MSB of each color to abjust to the interface width
>> used by the panel.
>>
>> This results on 18 bits (and probably 16 bits display as well) in colors
>> being displayed poorly, because the MSB are obviously the most important
>> bits for each color definition.
>>
>> The default controller behaviour when using an interface width smaller
>> than the color depth is to drop the LSBs of each color, which makes more
>> sense because you lose the least important part of the color definition.
>>
>> So, to fix the colors display, just get back to the default controller
>> behaviour.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> Did you receive my latest email? Check M28EVK (imx28-m28evk.dts), it uses 18bit 
> LCD and works without this patch I think.

Thanks for the pointer. You mentionned in your other mail that it was
wired on 24bits but that the screen is actually 18 bits. I went to
search for the schematics to look at the wirings to see what could
differ, but I couldn't find any for the M28EVK. Are they publicly available?

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
