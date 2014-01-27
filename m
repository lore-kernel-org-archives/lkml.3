Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaA0KKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:10:44 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48284 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaA0KKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:10:42 -0500
MIME-Version: 1.0
In-Reply-To: <20140126231543.GN11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
	<20140126211357.6fa68909@endymion.delvare>
	<52E573B6.9040903@roeck-us.net>
	<20140126214936.7736f530@endymion.delvare>
	<20140126212256.GK11727@sirena.org.uk>
	<20140126224425.724698cd@endymion.delvare>
	<20140126231543.GN11727@sirena.org.uk>
Date: Mon, 27 Jan 2014 11:10:41 +0100
X-Google-Sender-Auth: xAj0EC2Uwt1LF5tDBIiKHYU-ICE
Message-ID: <CAMuHMdXn=PC9+gZC05_yufLhPgYUy2FhcocRpY-Qatux=kftiA@mail.gmail.com>
Subject: Re: lm90 driver no longer working on PCs in 3.13
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Wei Ni <wni@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 12:15 AM, Mark Brown <broonie@kernel.org> wrote:
>> No, you don't get what I'm saying. For PC users, the lm90 did not
>
> I understand perfectly well thank you very much.
>
>> request a regulator and things worked because the kernel isn't supposed
>> to take care about things like that on PC machines. Now that the lm90
>> driver does request a regulator, it fails on PC machines because no
>> regulator is declared.
>
> If and only if the user has enabled the regulator API on a platform that
> hasn't fully configured it; if the user has not enabled the regulator
> API it'll stub itself out and they'll never see it.
>
>> Don't tell me that it is expected that things will fail if
>> CONFIG_REGULATOR is enabled on a system which doesn't need it. It
>> doesn't make any sense. If kernels would fail as soon as any enabled
>> option wasn't actually needed, no system would boot out there.
>
> It's very easy to generate unbootable kernels by changing the kernel
> config, I'd not immediately expect a randomly generated config to do
> anything useful and things like FW_LOADER_USER_HELPER can be rather
> miserable if you turn them on (that one produces enormous delays during
> init which look awfully like hangs when you're watching your board
> boot).

This is not just a randomly generated config where you disable critical
options. Just enabling a subsystem like the regulator subsystem shouldn't
give you an unbootable kernel. It's even needed, think multi-platform
kernels.
Typically, I'd expect allmodconfig/allyesconfig kernels to actually boot
(ignoring RAM size issues etc.).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
