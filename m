Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3EXQLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:11:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:17032 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3EXQLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:11:05 -0400
Message-ID: <519F9116.8060109@atmel.com>
Date: Fri, 24 May 2013 18:11:02 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: <linus.walleij@linaro.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <linux-arm@overkiz.com>
Subject: Re: [GIT PULL] at91: cleanup (pinctrl macros, defconfigs) for 3.11
 #1
References: <1368799336-25226-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1368799336-25226-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/2013 16:02, Nicolas Ferre :
> Arnd, Olof,
>
> Here is the first AT91 cleanup pull-request for 3.11. I is dominated by a big
> update of DT files because of the move to macros in pinctrl. As we plan to
> make this "cleanup" series the base of all our work on AT91 for 3.11, we would
> like to see it appearing early in arm-soc and linux-next: this is why we send
> it to you right now.
>
> We have colected the Acked-by from Linus Walleij and we all think that it makes
> sense to merge this material through arm-soc tree:
> - is touches nearly nothing of pinctrl actual code (a header file)
> - all dtsi/dts modifications for 3.11 will need this as a codebase for avoiding
>    merging nightmare
>
> I hope that it is okay with you.
>
> Thanks, best regards,
>
> The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:
>
>    Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
>
> are available in the git repository at:
>
>    git://github.com/at91linux/linux-at91.git tags/at91-cleanup

Arnd, Olof,

After having sent the second "fixes" pull-request to you, I want to warn 
you about merging conflicts concerning this "cleanup" pull-request for 3.11.

2 merging conflicts are appearing when placing the "cleanup" branch on 
top of the "fixes" material contained today in at91-fixes tag.
To address this, I have pushed a resolution branch on our usual git tree:

git://github.com/at91linux/linux-at91.git   at91-3.11-cleanup1+resolved

In case of any question, please let me know. If you want me to rebase 
the original tag that I've sent you, I can do it as well.

Thanks, best regards,

> for you to fetch changes up to b3f442b0eedbc20b5ce3f4a96530588d14901199:
>
>    ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)
>
> ----------------------------------------------------------------
> Big update with pinctrl by use of macros and
> header files. Increases readability and avoid
> typos.
> Update of AT91 defconfigs and merge of defconfigs for
> SoC look-alike:
> sam9260/9g20 and sam9261/9g10.
>
> ----------------------------------------------------------------
> Jean-Christophe PLAGNIOL-VILLARD (6):
>        ARM: at91: dt: use #include for all device trees
>        ARM: at91: dt: switch to standard GPIO flag defines.
>        ARM: at91: dt: add pinctrl pre-processor define
>        ARM: at91: dt: switch to pinctrl to pre-processor
>        ARM: at91: dt: switch to standard IRQ flag defines
>        ARM: at91: udpate defconfigs
>
>   arch/arm/boot/dts/aks-cdu.dts                      |  12 +-
>   arch/arm/boot/dts/animeo_ip.dts                    |  18 +-
>   arch/arm/boot/dts/at91-ariag25.dts                 |   6 +-
>   arch/arm/boot/dts/at91rm9200.dtsi                  | 207 ++++----
>   arch/arm/boot/dts/at91rm9200ek.dts                 |  10 +-
>   arch/arm/boot/dts/at91sam9260.dtsi                 | 215 ++++-----
>   arch/arm/boot/dts/at91sam9263.dtsi                 | 203 ++++----
>   arch/arm/boot/dts/at91sam9263ek.dts                |  24 +-
>   arch/arm/boot/dts/at91sam9g15.dtsi                 |   2 +-
>   arch/arm/boot/dts/at91sam9g15ek.dts                |   4 +-
>   arch/arm/boot/dts/at91sam9g20.dtsi                 |   2 +-
>   arch/arm/boot/dts/at91sam9g20ek.dts                |   6 +-
>   arch/arm/boot/dts/at91sam9g20ek_2mmc.dts           |  10 +-
>   arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |  28 +-
>   arch/arm/boot/dts/at91sam9g25.dtsi                 |   2 +-
>   arch/arm/boot/dts/at91sam9g25ek.dts                |   4 +-
>   arch/arm/boot/dts/at91sam9g35.dtsi                 |   2 +-
>   arch/arm/boot/dts/at91sam9g35ek.dts                |   4 +-
>   arch/arm/boot/dts/at91sam9g45.dtsi                 | 213 ++++-----
>   arch/arm/boot/dts/at91sam9m10g45ek.dts             |  38 +-
>   arch/arm/boot/dts/at91sam9n12.dtsi                 | 141 +++---
>   arch/arm/boot/dts/at91sam9n12ek.dts                |  14 +-
>   arch/arm/boot/dts/at91sam9x25.dtsi                 |  22 +-
>   arch/arm/boot/dts/at91sam9x25ek.dts                |   4 +-
>   arch/arm/boot/dts/at91sam9x35.dtsi                 |   2 +-
>   arch/arm/boot/dts/at91sam9x35ek.dts                |   4 +-
>   arch/arm/boot/dts/at91sam9x5.dtsi                  | 279 +++++------
>   arch/arm/boot/dts/at91sam9x5cm.dtsi                |   8 +-
>   arch/arm/boot/dts/at91sam9x5ek.dtsi                |  14 +-
>   arch/arm/boot/dts/ethernut5.dts                    |   6 +-
>   arch/arm/boot/dts/evk-pro3.dts                     |   6 +-
>   arch/arm/boot/dts/ge863-pro3.dtsi                  |   2 +-
>   arch/arm/boot/dts/kizbox.dts                       |  16 +-
>   arch/arm/boot/dts/mpa1600.dts                      |   4 +-
>   arch/arm/boot/dts/pm9g45.dts                       |  22 +-
>   arch/arm/boot/dts/sama5d3.dtsi                     | 520 +++++++++++----------
>   arch/arm/boot/dts/sama5d31ek.dts                   |   6 +-
>   arch/arm/boot/dts/sama5d33ek.dts                   |   4 +-
>   arch/arm/boot/dts/sama5d34ek.dts                   |   6 +-
>   arch/arm/boot/dts/sama5d35ek.dts                   |   4 +-
>   arch/arm/boot/dts/sama5d3xcm.dtsi                  |   4 +-
>   arch/arm/boot/dts/sama5d3xdm.dtsi                  |   2 +-
>   arch/arm/boot/dts/sama5d3xmb.dtsi                  |  26 +-
>   arch/arm/boot/dts/tny_a9260.dts                    |   4 +-
>   arch/arm/boot/dts/tny_a9263.dts                    |   4 +-
>   arch/arm/boot/dts/tny_a9g20.dts                    |   4 +-
>   arch/arm/boot/dts/usb_a9260.dts                    |   4 +-
>   arch/arm/boot/dts/usb_a9260_common.dtsi            |   6 +-
>   arch/arm/boot/dts/usb_a9263.dts                    |   8 +-
>   arch/arm/boot/dts/usb_a9g20-dab-mmx.dtsi           |  22 +-
>   arch/arm/boot/dts/usb_a9g20.dts                    |   4 +-
>   arch/arm/configs/at91_dt_defconfig                 |  55 ++-
>   arch/arm/configs/at91rm9200_defconfig              | 218 ++-------
>   ...am9g20_defconfig => at91sam9260_9g20_defconfig} |  67 ++-
>   arch/arm/configs/at91sam9260_defconfig             |  91 ----
>   ...am9261_defconfig => at91sam9261_9g10_defconfig} |  19 +-
>   arch/arm/configs/at91sam9263_defconfig             |  39 +-
>   arch/arm/configs/at91sam9g45_defconfig             |  94 ++--
>   arch/arm/configs/sama5_defconfig                   |  35 +-
>   arch/arm/mach-at91/Kconfig.non_dt                  | 159 +++----
>   arch/arm/mach-at91/Makefile                        |   2 -
>   arch/arm/mach-at91/board-sam9261ek.c               |  28 +-
>   include/dt-bindings/pinctrl/at91.h                 |  35 ++
>   63 files changed, 1407 insertions(+), 1617 deletions(-)
>   rename arch/arm/configs/{at91sam9g20_defconfig => at91sam9260_9g20_defconfig} (67%)
>   delete mode 100644 arch/arm/configs/at91sam9260_defconfig
>   rename arch/arm/configs/{at91sam9261_defconfig => at91sam9261_9g10_defconfig} (91%)
>   create mode 100644 include/dt-bindings/pinctrl/at91.h
>


-- 
Nicolas Ferre
