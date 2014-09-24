Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaIXKuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:50:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:20941 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaIXKuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:50:06 -0400
Message-ID: <5422A1DA.1040102@atmel.com>
Date: Wed, 24 Sep 2014 12:50:02 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <arm@kernel.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.18 #2 (bis)
References: <1409934969-11584-1-git-send-email-nicolas.ferre@atmel.com> <1410797563-13378-1-git-send-email-nicolas.ferre@atmel.com> <20140924045906.GC24803@localhost>
In-Reply-To: <20140924045906.GC24803@localhost>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/2014 06:59, Olof Johansson :
> On Mon, Sep 15, 2014 at 06:12:43PM +0200, Nicolas Ferre wrote:
>> Arnd, Olof, Kevin,
>>
>> I re-send this pull-request with the work done by Maxime to take Arnd's
>> comments into annount: removal of the early_platform devices, and by keeping
>> the old mechanism with a function exported by the PIT timer and called by the
>> board files.
>>
>> Here is the old message that I sent you: just as a reference.
>> "
>> This pull-request is focused on the work that Maxime did for migrating our
>> timer (PIT) to the clocksource sub-system. A big cleanup happened which allows
>> us to be even closer to the point when we have only the bare minimum in our
>> formerly crowded mach-at91 directory.
>> "
>>
>> This pull-request goes on top of what is already in your at91/drivers branch.
>>
>> Thanks, best regards,
>>
>> The following changes since commit 405a72c5e78b5c560c8b2711d4000fa5eb063e1b:
>>
>>   power: reset: at91-poweroff: fix wakeup status register index (2014-09-01 18:40:44 +0200)
>>
>> are available in the git repository at:
>>
>>   git://github.com/at91linux/linux-at91.git tags/at91-drivers2
>>
>> for you to fetch changes up to b052ff30cd450c91a32e8e928979bca021462996:
>>
>>   ARM: at91: PIT: Move the driver to drivers/clocksource (2014-09-15 17:55:48 +0200)
>>
>> ----------------------------------------------------------------
>> Second drivers series for AT91/3.18:
>> - move of the PIT (basic timer) from mach-at91 to its proper location:
>>   drivers/clocksource
>> - big cleanup of this driver along the way
> 
> Thanks, merged.

Thanks Olof, but there is a merge issue in the merge commit
58c19114886d5352c019979b84f5375970d81f05 (Merge branch 'next/drivers'
into for-next). In fact the sama5_dt_timer_init() and
ksz9021rn_phy_fixup() functions must be completely removed in this
arch/arm/mach-at91/board-dt-sama5.c file.

This is causing the errors seen in your and Kevin's buildbots:
http://images.armcloud.us/kernel-ci//arm-soc/v3.17-rc4-608-g58bf4da/arm-sama5_defconfig/build.log
and
http://arm-soc.lixom.net/buildlogs/arm-soc/v3.17-rc4-608-g58bf4da/buildall.arm.sama5_defconfig.log.failed

I pushed a branch for conflict resolutions here:
git://github.com/at91linux/linux-at91.git at91-3.18-resolved2
https://github.com/at91linux/linux-at91/commits/at91-3.18-resolved2

Bye,
-- 
Nicolas Ferre
