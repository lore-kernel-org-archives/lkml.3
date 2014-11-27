Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaK0Lm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:42:29 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:59399 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaK0Lm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:42:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for CMU_BUS{0|1|2} domains
Date: Thu, 27 Nov 2014 12:41:51 +0100
Message-ID: <6217579.xNXtO7YiDs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417073716-22997-12-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com> <1417073716-22997-12-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:u74OeOibnuziNcGQnnwMgK0LrsyY9MTmlnHCOD/SNcy
 M71WA/wg5fRZ9lPMqe1S5wwNHvVEoU2aumjxjg9yUAfKjECE2k
 ktgUv2woaNWi0U/HN0CIcHXogKc8oQn6kY1vnNwxuhaRvVJTaD
 vs0JJut/wN1fCk1NpkZ0/wQWumheVo7tgCAtJSlhuykC5AakpK
 AZ/GgwcLvhvHPuTnHvQEfYOyd8dwLUYWHrZSICOOvKz4F/4OGx
 ZMtt8G7MCHEmtVG09IiYIWzUo1Z976buDS79cbededXjuBJ44b
 i9B3PTebSFJ3gAoKGaTynXJlo3g54oUAQ76ck7QW7kDwND6S+A
 I7DtSaV8hi9IOUwNHsWQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 16:35:08 Chanwoo Choi wrote:
> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
> +    and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
> +    which generates global data buses clock and global peripheral buses clock.
>  
>  - reg: physical base address of the controller and length of memory mapped
>    region.
> 

This looks like you are duplicating the bindings and the code, but
it's really the same hardware multiple times with minor variations
that you should be able to describe properly here. Why not make
three nodes with the same compatible string and have them handled
by the same code?

	Arnd
