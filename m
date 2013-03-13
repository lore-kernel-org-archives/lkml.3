Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3CMKNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:13:00 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:50910 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3CMKM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:12:58 -0400
Message-ID: <51405126.3090009@atmel.com>
Date: Wed, 13 Mar 2013 11:12:54 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>, Olof Johansson <olof@lixom.net>,
        "Arnd Bergmann" <arnd@arndb.de>
CC: <FlorianSchandinat@gmx.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <jacmet@sunsite.dk>
Subject: Re: [PATCH 0/5] at91: atmel_lcdfb: regression fixes and cpu_is removal
References: <cover.1360340791.git.nicolas.ferre@atmel.com> <20130210004740.GH16278@quad.lixom.net> <CAMgPeKV4=C_msvZixVS-o3-QHaJxZP7T4EwLa9vnmYgVheXHgQ@mail.gmail.com> <5139B169.7050807@atmel.com>
In-Reply-To: <5139B169.7050807@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 10:37 AM, Nicolas Ferre :
> On 02/10/2013 07:45 PM, Johan Hovold :
>> On Sun, Feb 10, 2013 at 1:47 AM, Olof Johansson <olof@lixom.net> wrote:
>>> On Fri, Feb 08, 2013 at 05:35:13PM +0100, Nicolas Ferre wrote:
>>>> These patches fix a regression in 16-bpp support for older SOCs which
>>>> use IBGR:555 rather than BGR:565 pixel layout. Use SOC-type to
>>>> determine if the controller uses the intensity-bit and restore the
>>>> old layout in that case.
>>>>
>>>> The last patch is a removal of uses of cpu_is_xxxx() macros in
>>>> atmel_lcdfb with a platform-device-id table and static
>>>> configurations.
>>>>
>>>>
>>>> Patches from Johan Hovold taken from: "[PATCH 0/3] atmel_lcdfb: fix
>>>> 16-bpp regression" and "[PATCH v2 0/3] ARM: at91/avr32/atmel_lcdfb:
>>>> remove cpu_is macros" patch series to form a clean patch series with
>>>> my signature.
>>>>
>>>> Arnd, Olof, as it seems that old fbdev drivers are not so much
>>>> reviewed those days, can we take the decision to queue this material
>>>> through arm-soc with other AT91 drivers updates?
>>>
>>> It would be beneficial to get an ack from Florian. Was he involved in
>>> the review of the code that regressed 16-bpp support in the first
>>> place? When was the regression introduced?
>>
>> In v3.4 by commit 787f9fd2328 ("atmel_lcdfb: support 16bit BGR:565 mode,
>> remove unsupported 15bit modes").
> 
> Arnd, Olof,
> 
> Please tell me if I can do something to ease the adoption of these
> patches during 3.9-rc timeframe (I can rebase it on top of 3.9-rc1 to
> avoid any conflict: the file board-neocore926.c was removed during the
> merge window).
> Johan has written the series a long time ago and we still do not have it
> in mainline.
> 
> If the option to ask Andrew is better in your opinion, please tell me.

In case we end-up with an agreement on the path those fixes should
follow, here is the location of my updated material rebased on top of 3.9-rc2:

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git at91-3.9-fixesLCD

for you to fetch changes up to bbd44f6bd9d1aa735b180b29b5719d63a8e87b55:

  ARM: at91/avr32/atmel_lcdfb: add platform device-id table (2013-03-13 11:05:12 +0100)

----------------------------------------------------------------
Johan Hovold (5):
      atmel_lcdfb: fix 16-bpp modes on older SOCs
      ARM: at91: fix LCD-wiring mode
      ARM: at91/avr32/atmel_lcdfb: add bus-clock entry
      atmel_lcdfb: move lcdcon2 register access to compute_hozval
      ARM: at91/avr32/atmel_lcdfb: add platform device-id table

 arch/arm/mach-at91/at91sam9261.c         |   2 +
 arch/arm/mach-at91/at91sam9261_devices.c |   6 +-
 arch/arm/mach-at91/at91sam9263.c         |   1 +
 arch/arm/mach-at91/at91sam9263_devices.c |   2 +-
 arch/arm/mach-at91/at91sam9g45.c         |   2 +
 arch/arm/mach-at91/at91sam9g45_devices.c |   6 +-
 arch/arm/mach-at91/at91sam9rl.c          |   1 +
 arch/arm/mach-at91/at91sam9rl_devices.c  |   2 +-
 arch/avr32/mach-at32ap/at32ap700x.c      |   6 +-
 drivers/video/atmel_lcdfb.c              | 130 +++++++++++++++++++++++++++--------
 include/video/atmel_lcdc.h               |   4 +-
 11 files changed, 126 insertions(+), 36 deletions(-)


Thanks, best regards,
-- 
Nicolas Ferre
