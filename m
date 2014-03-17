Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbaCQCHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 22:07:48 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:34258 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbaCQCHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 22:07:47 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.129.85]
In-Reply-To: <1395020870-18107-1-git-send-email-linux@roeck-us.net>
References: <1395020870-18107-1-git-send-email-linux@roeck-us.net>
Date: Mon, 17 Mar 2014 10:07:46 +0800
Message-ID: <CAFRkauDEBe+XStLJSiMzvNOxpFZ2iBGD36-Brq9oHN2RRa+rog@mail.gmail.com>
Subject: Re: [PATCH] spi: sc18is602: Don't be that restrictive with the
 maximum transfer speed
From: Axel Lin <axel.lin@ingics.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-17 9:47 GMT+08:00 Guenter Roeck <linux@roeck-us.net>:
> Commit 09e99bca8 (spi: sc18is602: Convert to let spi core validate
> transfer speed) made the maximum transfer speed much more restrictive
> than before. The transfer speed used to be adjusted to 1/4 of the chip
> clock rate if a higher transfer speed was requested. Now such transfers are
> simply rejected. With default settings, this causes, for example, a transfer
> request at 2 mbps to be rejected because the maximum speed with the default
> chip clock is 1.843 mbps.
>
> This is unnecessarily restrictive and causes unnecessary failures. Loosen
> the limit to accept transfers up to 50% of the clock rate and adjust
> the speed as needed when setting up the actualt transfer.

I suppose this controller can only set to SC18IS602_MODE_CLOCK_DIV_4 for the
highest transfer speed. If this is the case, master->max_speed_hz should be
hw->freq / 4.

Now I'm thinking if it is ok to use master->max_speed_hz as transfer speed when
xfer->speed_hz > master->max_speed_hz. And it should be handled in spi core.
I'm sending a RFC patch now.

Regards,
Axel
