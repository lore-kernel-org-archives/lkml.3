Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3CLObR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:31:17 -0400
Received: from void.printf.net ([89.145.121.20]:37096 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab3CLObQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:31:16 -0400
From: Chris Ball <cjb@laptop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Liu <keyuan.liu@gmail.com>,
        "linux-kernel\@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@ingics.com>, Jingoo Han <jg1.han@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        linux-mmc@vger.kernel.org
Subject: Re: FW: Regulator API ignored return values
References: <25B60CDC2F704E4E9D88FFD52780CB4C0BDEB0547F@SC-VEXCH1.marvell.com>
	<CADz5_g+KfxL43BKKsgZZ3Xg4sZWE4-ZaFpFhphKrfj9yK59-XA@mail.gmail.com>
	<201303121403.09315.arnd@arndb.de>
Date: Tue, 12 Mar 2013 10:30:55 -0400
In-Reply-To: <201303121403.09315.arnd@arndb.de> (Arnd Bergmann's message of
	"Tue, 12 Mar 2013 14:03:09 +0000")
Message-ID: <87y5dsheqo.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 12 2013, Arnd Bergmann wrote:
>> Need add regulator_put here since regulator_get has succeed?
>
> Hmm, we still don't actually bail out if the error is encountered, so
> the reference count is balanced with the current patch, but I maybe
> a failed regulator_enable() should actually be a fatal error?

The reason I didn't make it a fatal error is that this is just vqmmc
(responsible for moving from 3.3V to 1.8V for UHS modes), not the
main vmmc regulator.  We can just disable those UHS modes from the
capabilities on the host if vqmmc is missing, or failed to enable,
or doesn't support those voltages, and that's what the code does now.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
