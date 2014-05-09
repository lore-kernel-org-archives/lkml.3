Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaEIMUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:20:22 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:64181 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaEIMUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:20:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140424162558.GB12304@sirena.org.uk>
References: <1398350916-885-1-git-send-email-ch.naveen@samsung.com> <20140424162558.GB12304@sirena.org.uk>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 9 May 2014 17:50:00 +0530
Message-ID: <CAHfPSqB5+mLiC07jbEpeUgW63pZVk700SkYGxToO7GRAsFm_nQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: exynos5: Initialise Samsung High Speed I2C
 controller early
To: Mark Brown <broonie@kernel.org>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        sjg@chromium.org, grundler@chromium.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de, cpgs@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 24 April 2014 21:55, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Apr 24, 2014 at 08:18:36PM +0530, Naveen Krishna Chatradhi wrote:
>> This patch moves initialization code to subsys_initcall() to ensure
>> that the i2c bus is available early so the regulators can be quickly
>> probed and available for other devices on their probe() call.
>
>> Such solution has been proposed by Mark Brown to fix the problem of
>> the regulators not beeing available on the peripheral device probe():
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/011971.html
>
> What specifically is this needed for?  We *should* be able to use
> deferred probe for most things, but I know that not all subsystems are
> able to yet.
DRM related drivers like DP, FIMD, HDMI, Mixer wants to be probed ASAP
during the boot.
The real problem comes when, one of these drivers do a regulator_get().

If the physical supply  is not enabled/hookedup the regulator_get() call
assumes that physical supply is present and returns a
"dummy_regulator" (But, not an error).

Because of which, Display and several other devices fails to work.

I2C, I2C_TUNNEL, SPI and DMA drivers are required as subsys_initcall()
for similar reason.

-- 
Shine bright,
(: Nav :)
