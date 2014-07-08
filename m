Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaGHOLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:11:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26439 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaGHOLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:11:22 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-6d-53bbfc07191f
Message-id: <53BBFBE7.5080209@samsung.com>
Date: Tue, 08 Jul 2014 16:10:47 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <1404496099-26708-19-git-send-email-t.figa@samsung.com>
 <4267278.JdVSGvRhtr@wuerfel>
In-reply-to: <4267278.JdVSGvRhtr@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xK7rsf3YHGxxdr27xd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CV8X7tU6aC
	n1wVW/cdZWlgfMTRxcjJISFgItFx6CsLhC0mceHeerYuRi4OIYGljBIT191lgXA+M0p07/vD
	DlLFK6Al8ebYXkYQm0VAVeL+23tgcTYBNYnPDY/YQGx+oJo1TdeBmjk4RAUiJB5fEIJoFZT4
	Mfke2DIRAXeJddPnsYLMZxbYziRx88tesDnCAq4SW85dZYZYPJtRon/eaiaQBKeApsS5rgPM
	IDazgI7E/tZpbBC2vMTmNW+ZJzAKzkKyZBaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L
	10vOz93ECImdrzsYlx6zOsQowMGoxMNrcH53sBBrYllxZe4hRgkOZiUR3i+ngEK8KYmVValF
	+fFFpTmpxYcYmTg4pRoYGW0LGDR+GwvxeyodVLzWH319wvpw//xQI4YKrUsMj850fqk14W5o
	e/K/WW+LllDgihuZH+TOzejaErPE/Zdx17FkUdd0hhuvN03lTd22oWhLueKLqRd/9C5IExOd
	blAyqT9kyQp3aSuhToZrGWpGy41DPi1WOrJzUcmx/592qu455scS0saixFKckWioxVxUnAgA
	hWmZF3sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.07.2014 22:23, Arnd Bergmann wrote:
> On Friday 04 July 2014 19:48:18 Tomasz Figa wrote:
>> After refactoring suspend/resume, which was last part with dependencies
>> on legacy code, all Kconfig symbols related to Samsung ATAGS support can
>> be deselected and more unused code removed. This includes most of s5p-*
>> code as well, as s5pv210 was their last user.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> 
> I actually found a few more, see patch below. Feel free to merge it
> into yours.

Will add your patch to this series, if sending v2. Otherwise I guess it
could be applied on top of it.

> 
> As discussed on IRC, I have also done an experimental patch to move
> the few contents of mach-s5pv210 into mach-exynos, which turned out
> very simple and should be uncontroversial but needs more testing.
> 
> Finally, there is some more cleanup potential in moving things out
> of plat-samsung into the individual platforms (s3c24xx, s3c64xx,
> exynos including s5pv210), as a lot of files are now only used
> on one of them.
> 
> I tried moving everything that the combined mach-exynos needs out
> of plat-samsung, but that resulted in about 500-600 lines of duplication
> between s3c and exynos for pm-common.c, pm-common.h, pmdebug.c
> and pm-check.c, so those four files should probably remain shared
> for now.

OK.

Best regards,
Tomasz
