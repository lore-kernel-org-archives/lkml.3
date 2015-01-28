Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbbA1Uah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:30:37 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43236 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbbA1Ua0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:30:26 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-15-54c8ef8b0023
Message-id: <54C8F01B.5030300@samsung.com>
Date: Wed, 28 Jan 2015 15:20:11 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: lee.jones@linaro.org, dmitry.torokhov@gmail.com, a.zummo@towertech.it
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, paul.gortmaker@windriver.com,
        sachin.kamat@linaro.org, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-pm@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH v5 0/3] mfd: max8997: add regmap support
References: <1415776996-11569-1-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1415776996-11569-1-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t/xa7rd70+EGDz5Y2ix5OJVdoupD5+w
	WRzdOZHJ4vqX56wWk568Z7Y4vOgFo8XElZOZLV6/MLS4//Uoo8W3Kx1MFjc/fWO1uLxrDpvF
	1jfrGC0+9x5htLjduILN4tre48wWu3c9ZbXY39nBaHHyTy+jxeluVovTu0scRD12zrrL7rFn
	4kk2j80rtDw2repk87hzbQ+bx7yTgR575v9g9ejbsorRY/q8n0wenzfJeazfspUpgDuKyyYl
	NSezLLVI3y6BK6Nz0j7WgqnCFW923WNvYHzG18XIwSEhYCLx7796FyMnkCkmceHeerYuRi4O
	IYGljBLN7/eyQjgfGSVuvp7AAlLFK6Al8bX/GxuIzSKgKnG2+T07iM0moCOx5fsERhBbVCBC
	4sOqr2wQ9YISPybfA+sVEfCU6Ox/wQxiMwvsY5ZYs1kPxBYWsJE403+eFcQWEnCVmPfsHVgv
	p4CbRN+tgywghzIL6Encv6gF0SovsXnNW+YJjAKzkGyYhVA1C0nVAkbmVYyiqaXJBcVJ6blG
	esWJucWleel6yfm5mxgh8fl1B+PSY1aHGAU4GJV4eBl8ToQIsSaWFVfmHmKU4GBWEuENegkU
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwFgjkKN14lli9tszapEXN//bcWQ2n6JtjXW/X1fC24UM
	y7P3KFz2+1o13ymxfQ+TaJnx5ItX/a/uZ/3V9ffuYa/4OjnxKHbZmG87pL2+dzwwyK/gjDuV
	ZNa05aiiXXAte661W+O6+9el2uI+dAlrrz+osf7K+cLiPW93/Zls+fOzdHDl+x/9JkosxRmJ
	hlrMRcWJAOKahZ+tAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first version of this patchset was send to kernel list almost 9
months ago and still I don't have all needed Acks. The missing ones are
for changes in INPUT and RTC subsystems.

Dmitry, Alessandro, could you please have a look at this patches and
give your Acks?

Best regards,
Robert Baldyga

On 11/12/2014 08:23 AM, Robert Baldyga wrote:
> This patchset modifies max8997 driver and associated function drivers to use
> register maps instead of operating directly on i2c bus. This change allowed
> to simplify irq handling, and to move some initializations to individual
> function drivers. Hence now when some functions are not enabled, their i2c
> clients, regmaps and irqs are not registered.
> 
> Because patches are under review for very long time and I still don't have
> all needed Acks, I'm resending this series rebased to the latest next branch.
> 
> Best regards
> Robert Baldyga
> Samsung R&D Institute Poland
> 
> Changelog:
> 
> v5:
> - rebase patches to last next branch
> 
> v4:
> - remove patch moving regmap handling to function drivers
> 
> v3: https://lkml.org/lkml/2014/3/13/101
> - fix error handling
> - fix deinitializations order
> - move muic irq enum values renaming to separate patch
> 
> v2: https://lkml.org/lkml/2014/3/12/237
> - rebase patches on Lee Jones' MFD tree
> - add missing selects in Kconfig
> - add missing deinitializations
> - add interrupt disabling when suspend
> - few minor changes and typo fixes
> 
> v1: https://lkml.org/lkml/2014/3/11/291
> 
> Robert Baldyga (3):
>   mfd: max8997: use regmap to access registers
>   mfd: max8997: handle IRQs using regmap
>   mfd: max8997: change irq names to upper case
> 
>  drivers/extcon/extcon-max8997.c     |  66 +++---
>  drivers/input/misc/max8997_haptic.c |  34 ++--
>  drivers/leds/leds-max8997.c         |  13 +-
>  drivers/mfd/Kconfig                 |   3 +-
>  drivers/mfd/Makefile                |   2 +-
>  drivers/mfd/max8997-irq.c           | 387 ------------------------------------
>  drivers/mfd/max8997.c               | 245 +++++++++++++++--------
>  drivers/power/max8997_charger.c     |  33 +--
>  drivers/regulator/max8997.c         |  87 ++++----
>  drivers/rtc/rtc-max8997.c           |  58 +++---
>  include/linux/mfd/max8997-private.h |  82 ++++++--
>  11 files changed, 381 insertions(+), 629 deletions(-)
>  delete mode 100644 drivers/mfd/max8997-irq.c
> 

