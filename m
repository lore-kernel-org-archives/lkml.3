Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3LMQRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:17:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60676 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LMQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:17:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
Date: Fri, 13 Dec 2013 17:17:25 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux@arm.linux.org.uk, olof@lixom.net
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com> <1386945188-8316-2-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1386945188-8316-2-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312131717.25435.arnd@arndb.de>
X-Provags-ID: V02:K0:daur9HR0p+dIG9gdan+txndOVuD9lkyZH/qb9dCYhUS
 kVSrpgIIRHjgvwNze9HDLyiq5/UCsNS87A6IR5ZH9+aV7XJhtA
 Bz5jarkXJaPfcBqSVvKfse4lYW5M2fvpRWiiK/vz5JRVaIPKPh
 XuL19RmDh3+VM1EPR5gDoSyp+++iOxccBW3BhSKXUKBYIcgZAI
 xqYK8HpiJG4wUomwFONEPlXfZdia+cKy0lGCW5IbHpAPaE58iD
 2JSdF8pSunbVIyXpObTG2yrGA8wFcs092fBShyIdsHygEzcow5
 YOQ1yNe1zk1YjwuJL9A4qLxlBOLkH1Os2tIoms5ktRT/QQdqKO
 D3vNwM9qA44g+zH5+RwM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 December 2013, Jonas Jensen wrote:
> The MOXA ART SoC is based on Faraday's FA526. This is a ARMv4 32-bit
> 192 MHz CPU with MMU and 16KB/8KB D/I-cache.
> 
> Add platform support for this SoC.
> 
> Also add UC-7112-LX as a machine.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Let's make sure we get this merged this time. I'm definitely fine with this
version going in. My questions are just for clarification on my part for
potential future follow-ups.

Acked-by: Arnd Bergmann <arnd@arndb.de>

> diff --git a/arch/arm/configs/moxart_defconfig b/arch/arm/configs/moxart_defconfig
> new file mode 100644
> index 0000000..51f0f03
> --- /dev/null
> +++ b/arch/arm/configs/moxart_defconfig
> @@ -0,0 +1,148 @@
> +# CONFIG_LOCALVERSION_AUTO is not set
> +# CONFIG_SWAP is not set
> +CONFIG_SYSVIPC=y
> +CONFIG_NO_HZ=y
> +CONFIG_IKCONFIG=y

IIRC the separate defconfig is needed because we have never gotten a mixed fa526+arm9
kernel to boot, right? In theory it is supposed to work and there is most likely just
a small bug somewhere. Once that is working, we can think about adding a generic
multi_v4_v5_defconfig that handles all multipltform capable platforms along the lines
of multi_v7_defconfig.

> +static void __init moxart_dt_init(void)
> +{
> +       moxart_setup_restart();
> +       of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}

I've been out of the loop a bit here. I initially suggested having the restart
handler be part of the watchdog driver, and I thought you had done that in an
earlier version. What has changed your mind?

	Arnd
