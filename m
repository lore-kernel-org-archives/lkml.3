Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab3FMXNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:13:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44647 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3FMXNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:13:08 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-42-51ba520220c6
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'Luigi Semenzato'" <semenzato@chromium.org>,
        "'Ilho Lee'" <ilho215.lee@samsung.com>,
        =?UTF-8?B?J+q5gOydgOq4sCc=?= <eunki_kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
 <150901ce682e$1c3fca50$54bf5ef0$%kim@samsung.com>
 <CAD=FV=U9V-rgjcCusCvgw-SeUH-kDbozr_T-i1DcaXNXv48vxw@mail.gmail.com>
 <4661065.SXhmWQNl5M@flatron>
 <CAD=FV=Ukdpt4vMCZNySvKpHz6yGCP5X-LLAc1XdOAEAM8rr1fw@mail.gmail.com>
In-reply-to: <CAD=FV=Ukdpt4vMCZNySvKpHz6yGCP5X-LLAc1XdOAEAM8rr1fw@mail.gmail.com>
Subject: RE: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts before
 unmasking
Date: Fri, 14 Jun 2013 08:13:05 +0900
Message-id: <15e401ce688b$8fadadb0$af090910$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5oVjQLFff1Wh06TX6MWdyaq53mnAANK+jQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zI12moF2BBhcn61qcXXaQzeLZnSvM
	Fkf/LWS0mPJnOZPF5V1z2CxmnN/HZHHq+mc2i89Xv7BYfNuyjdFi1a4/jA5cHrMbLrJ47Jx1
	l93jzrU9bB5XTjSxevRtWcXo8XmTXABbFJdNSmpOZllqkb5dAldGf/9k5oLXnBUvFtxibWC8
	xd7FyMkhIWAi8WPVO2YIW0ziwr31bCC2kMAyRomTO9hgaq7N+8naxcgFFJ8OFN90hxHC+cso
	cf3FYyaQKjYBDYnD75+BTRURCJF41fucGaSIWeAek8SWsyeZITqWMUlsnPEGaC4HB6dAsMTS
	PdwgDcIC0RI7pn8FG8QioCoxqfsv2CBeAVuJs/dfskLYghI/Jt9jAbGZBdQlJs1bxAxha0s8
	eXeBFWSkBFD80V9diBuMJC7NOwxVLiKx78U7sKMlBHo5JI7vO8QMsUtA4tvkQywQvbISmw5A
	Q0JS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0veT83E2M
	kDifsIPx3gHrQ4zJQOsnMkuJJucD00ReSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhizFzpe8Ij8+yBca3aZ9LSZx722nUo297E0cRWp2NzQyrdu
	35zfW7R3+UTVsKoUffn5wMbyR01UR1iP181Vvgli7jsLhVLext+4YOJ/deHh772xWx8s5RYP
	WfDwotr+2W+M9q95ZnVfMcvpa4fKh5YZLE1OHzOm5Ei4Pkhn36t8V6r5/Nqw3wpKLMUZiYZa
	zEXFiQAAuU9fCQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsVy+t9jQV2moF2BBmdWa1icXXaQzeLZnSvM
	Fkf/LWS0mPJnOZPF5V1z2CxmnN/HZHHq+mc2i89Xv7BYfNuyjdFi1a4/jA5cHrMbLrJ47Jx1
	l93jzrU9bB5XTjSxevRtWcXo8XmTXABbVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QbUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjP7+ycwFrzkrXiy4xdrAeIu9i5GTQ0LAROLavJ+sELaYxIV769m6GLk4hASmM0qc
	3HSHEcL5yyhx/cVjJpAqNgENicPvn4F1iwiESLzqfc4MUsQscI9JYsvZk8wQHcuYJDbOeAM0
	i4ODUyBYYukebpAGYYFoiR3Tv4INYhFQlZjU/RdsEK+ArcTZ+y9ZIWxBiR+T77GA2MwC6hKT
	5i1ihrC1JZ68u8AKMlICKP7ory7EDUYSl+YdhioXkdj34h3jBEahWUgmzUIyaRaSSbOQtCxg
	ZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxGnknvYFzVYHGIUYCDUYmHN+HCzkAh1sSy
	4srcQ4wSHMxKIrzhf4FCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9McXkl8YbGJmZGlkZm
	FkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwMjUJOv3ysJluVmYyv5X00uY/vXe
	W/qnuHhhskeV+IdHN0pvXv89MSIl0Xr/tDPL5kuyS6QtCbiyMJFZg8V9BfOzwClnDui0bzmX
	WpUpPOXDbYZDraxfOiZbXGx7E+ytwF7BwDH77J2vgX/siz1MFQ5M5sp8475qT3KEre8K5ZWO
	T8K/cZ78sEaJpTgj0VCLuag4EQAdUnFJZwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> Tomasz,
> 
> On Thu, Jun 13, 2013 at 9:42 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> >> > BTW, probably we need a similar fixing in the mach-exynos/common.c
> >> > file
> >> > before pinct기 for distro...
> >>
> >> Is anyone using the functions in mach-exynos/common.c file anymore?  I
> >> thought that non-dt exynos support was going away and then we could
> >> just delete a whole lot of code from that file.
> >
> > I think Kukjin meant stable kernels that support Exynos boards using
> board
> > files and without pinctrl. Would make sense to have them fixed as well,
> I
> > guess.
>
Yes, correct. Thanks, Tomasz.

> Ah, makes sense.  Kukjin: do you know of someone who needs this
> (someone who is picking up linux-stable updates for exynos)?  I don't
> think it's important for ChromeOS for this particular patch.  If
> there's someone who needs this to officially land on linux-stable I'd
> be happy to review their backport of this patch.
> 
As you know, developing something like Android, Tizen use the stable kernel (long-term? I'm not sure) and there was a problem about this issue. So I mean, would be fixed for the stable kernel.

Thanks,
- Kukjin

