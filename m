Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaE3FLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:11:17 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52499 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaE3FLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:11:15 -0400
Message-ID: <538812E2.6070807@gmail.com>
Date: Fri, 30 May 2014 07:10:58 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Kevin Hilman <khilman@linaro.org>
CC: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v11 0/3] Exynos 5410 support
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com> <7hr43f9mmn.fsf@paris.lan> <538737CA.4070709@suse.de> <53874862.5080809@samsung.com> <538775AB.3000604@suse.de>
In-Reply-To: <538775AB.3000604@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On 29.05.2014 20:00, Andreas Färber wrote:

[snip]

> Some of the low-hanging fruit like no heartbeat/SD LEDs, no RTC, no
> usb3503 and thus no network I'm already looking into myself. For now I'm
> putting everything into the SMDK .dts, but I guess we'll need to split
> off -odroidxu.dts and -pinctrl.dtsi at some point.

Odroid XU needs its own dts for sure. I think you can make a copy of
SMDK dts and name it -odroidxu straightaway and work further with it.

exynos5410-pinctrl.dtsi is used for generic SoC-wide pinctrl
definitions, such as pin banks and pin groups. There should be no
board-specific things defined in it. Instead respective board dts should
have them.

> 
> What about graphics? The 5410 is an oddball in using PowerVR rather than
> Mali GPU - should a framebuffer on HDMI or DisplayPort work if we add DT
> nodes, or will the GPU require larger code changes?

The 3D GPU is completely independent from display controllers, which are
standard Samsung IP blocks, so you should be able to get unaccelerated
output using VP+Mixer+HDMI or FIMD+DP using existing drivers.

Best regards,
Tomasz
