Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaK1L4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:56:35 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:39356 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaK1L4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:56:33 -0500
MIME-Version: 1.0
In-Reply-To: <20141108001411.5629.25179.stgit@notabene.brown>
References: <20141108000919.5629.55381.stgit@notabene.brown>
	<20141108001411.5629.25179.stgit@notabene.brown>
Date: Fri, 28 Nov 2014 12:56:33 +0100
Message-ID: <CAPDyKFrx98NspRU1nV3uJ6XwTuA4tZQkrYTfDoeXGR+f5htODQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: core: allow a reset gpio to be configured.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Chris Ball <chris@printf.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2014 at 01:14, NeilBrown <neilb@suse.de> wrote:
> If the regulator supplying an SDIO device is shared
> with another device, the turning the regulator 'on' and 'off'
> will not actually cycle power and so will not reset
> the device.
>
> This is particularly a problem for some wi2si wireless modules which
> have a BT module on chip and can share power lines.
> Without the power-cycle, subsequent reset commands fail.
>
> So allow a 'reset' gpio to be specified.  If provided, the
> line is asserted during power-up.

There have been several attempts to fix similar issues as this patch
does. The latest one I posted a few month ago, which wasn't accepted.
http://comments.gmane.org/gmane.linux.power-management.general/46635

There has also been some off-list discussions on especially how we
should describe this in DT and there were actually some consensus made
around that. Still I haven't seen any patches on the mailing lists.

So to summarize, I am really concerned that we keep having these power
sequence issues for SDIO devices and right now the discussion has been
on hold. I am considering to hack on it myself, since I am tired of
waiting. :-)

Regarding this patch, I don't intent to apply it.

Kind regards
Uffe
