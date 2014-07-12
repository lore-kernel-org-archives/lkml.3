Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaGLW5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 18:57:30 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41510 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaGLW52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 18:57:28 -0400
Message-ID: <53C1BD51.9020500@samsung.com>
Date: Sun, 13 Jul 2014 07:57:21 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 00/19] ARM: SAMSUNG: S5PV210 platform clean-up
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com> <12714831.uRzVr7yNEz@wuerfel>
In-Reply-To: <12714831.uRzVr7yNEz@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/14 05:15, Arnd Bergmann wrote:
> On Friday 04 July 2014 19:48:00 Tomasz Figa wrote:
>> This huge series is a (hopefully final) attempt to convert Samsung S5PV210
>> into a DT-only and multiplatform-aware platform. It consists of several
>> steps to gradually replace legacy code with one meeting current standards
>> and then finally remove unused remnants.
>>
>> Patches 1-6 migrate the platform to fully use the Common Clock Framework
>> and get rid of legacy private clock code, of which s5pv210 was the last
>> user. Then patch 7 adds generic PHY driver for USB PHY on S5PV210 to allow
>> USB to be supported when using DT. Further three patches (8-10) add DT
>> support for mach-s5pv210 and necessary DT sources for currently supported
>> boards. Patch 11 removes board files and code directly related to them,
>> effectively making s5pv210 a DT-only platform. In next step, patches 12-15
>> prepare remaining code for multiplatform enablement, which is finally done
>> in patch 16. Patches 17-19 are a final clean-up, which remove a lot of
>> unused code left after making the last S5P platform DT-only.
>>
>> Build tested patch by patch on following configs:
>>   - s3c2410_defconfig (with DT support enabled),
>>   - s3c6400_defconfig (with DT support enabled),
>>   - s5pv210_defconfig (with DT support enabled after patches adding it),
>>   - exynos_defconfig,
>>   - exynos_defconfig with S5PV210 enabled in multiplatform configuration.
>>
>> Boot tested on s5pv210-goni board.
>>
>> Note that support for smdkc110, smdkv210 and torbreck boards is provided
>> by moving data from existing board files to new device tree sources. No
>> testing was performed due to mentioned board not being available anymore.
>> However I believe we agreed on this approach, because apparently there
>> are no active users of them. See the RFC from August 2013 asking for
>> removal of the whole platform [1].
>>
>> [1] http://www.mail-archive.com/linux-samsung-soc%40vger.kernel.org/msg21882.html
>>
>>
> Great work, everything
>
> Acked-by: Arnd Bergmann<arnd@arndb.de>
>
> I hope we can get this into linux-next soon so we can do some more
> cleanups on top.

Sorry for a little bit late applying, I just wanted to get ack from 
driver maintainers but... anyway I'll apply this series so you may see 
this on Monday in -next :)

Tomasz, many thanks for your effort and time.

- Kukjin
