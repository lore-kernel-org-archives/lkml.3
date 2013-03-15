Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3COL3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:29:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3COL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:29:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Fri, 15 Mar 2013 11:28:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-media" <linux-media@vger.kernel.org>,
        "linux-ide" <linux-ide@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        "linux-input" <linux-input@vger.kernel.org>,
        "linux-fbdev" <linux-fbdev@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <20130314140631.GM1906@pengutronix.de> <CAHkwnC9nGsdgOTQZ6VpeDyPWXw7tpP+2oHvnLv6LEr1cNdnrsg@mail.gmail.com>
In-Reply-To: <CAHkwnC9nGsdgOTQZ6VpeDyPWXw7tpP+2oHvnLv6LEr1cNdnrsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151128.48432.arnd@arndb.de>
X-Provags-ID: V02:K0:pPHwIuccT+9hXH1jjUyI9NIP48cxk4UrWXuoKW2ovxY
 9bcuwAzYt2/TMSWHAgwAeL2kiMW5+huN39i8sbSg8TIlICnJ7/
 yI/MRNrHv+YO6PTUtJShUrBWogRtB0QrTpOJfDUV3Tp3kgtFjR
 VBKJZnnATqWjsf2fRaY0eoJsN6Vr51bnrZy9Kso8V0G+EduwNL
 KWrlNtr2pyy0w1s6KQFHG53g+iatDHvfZ0xZABPEPtnZDT/ZDu
 83XmhU2CgM5jZUmWX1h/ju4PFIzVmsuYZIF0YIv9J95YrjncRa
 ioKjtYiyWPN7HzOLjJ7ca4opcUDMF2i4VuibLIIngRnQBTdcew
 2Nav1lFailTXLQFS+CZU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, Fabio Porcedda wrote:
> >> * Regarding the use of module_platform_driver_probe, I'm a little worried about
> >>   the interactions with deferred probing. I don't think there are any regressions,
> >>   but we should probably make people aware that one cannot return -EPROBE_DEFER
> >>   from a platform_driver_probe function.
> 
> The use of module_platform_driver_probe() doesn't change anything about that,
> it's exactly the same thing as using "return platform_driver_probe()".
> I'm right or I'm missing something? Maybe are you just speaking about
> the misuse of "platform_driver_probe"?

Yes, that was what I meant. The point is that if we need to review or remove
all uses of platform_driver_probe, it would be better not to introduce a
module_platform_driver_probe() interface to make it easier to use.

	Arnd
