Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbaJXN42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:56:28 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47054 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbaJXN40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:56:26 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-9c-544a5a87eb76
Message-id: <544A5A78.2030101@samsung.com>
Date: Fri, 24 Oct 2014 15:56:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Daniel Drake <drake@endlessm.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, ben-linux@fluff.org,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, thomas.abraham@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        InKi Dae <inki.dae@samsung.com>, geunsik.lim@samsung.com,
        jh80.chung@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com
Subject: Re: [PATCH 2/5] clk: samsung: exynos4415: Add clocks using common
 clock framework
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
 <1413775935-17743-2-git-send-email-cw00.choi@samsung.com>
 <CAD8Lp45F_6UWXx0f2xVGZL+Rgemg2fzkYhnfPdaeaiky0rKPgw@mail.gmail.com>
In-reply-to: <CAD8Lp45F_6UWXx0f2xVGZL+Rgemg2fzkYhnfPdaeaiky0rKPgw@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t/xa7rtUV4hBgtn6lj8nXSM3WLSugNM
	Fte/PGe1eDT/MbPFnwmtbBa7/t5ntJh0fwKLxY6GI6wWN361sVr0LrjKZnG26Q27xZQ/y5ks
	Nj2+xmpxedccNosZ5/cxWdy+zGux9PpFJounEy6yWZy6/hkoPvklm8WxGUsYLVbt+sNosXfn
	ZEYHcY8189YwerQ097B5/P41idFj0fcsj7+rXjB77Jx1l93jzrU9bB6bl9R7XDnRxOrRt2UV
	o8fnTXIB3FFcNimpOZllqUX6dglcGTPbPrAVLOWo6Dxq0cD4kK2LkZNDQsBE4u7L01C2mMSF
	e+uBbC4OIYGljBL3Xh5jhHA+MUoc621mBqniFdCSmLVoD1gHi4CqRMfFbawgNpuAoUTv0T5G
	EFtUIELi5N097BD1ghI/Jt9jAbFFgOp/LW9mBRnKLLCdTWLvksdgCWGBGImuWVfABgkJnGCU
	aLmT38XIwcEpECyxfoM7iMksoC4xZUouSAWzgLzE5jVvmScwCsxCsmEWQtUsJFULGJlXMYqm
	liYXFCel5xrpFSfmFpfmpesl5+duYoTE7dcdjEuPWR1iFOBgVOLh/bHFM0SINbGsuDL3EKME
	B7OSCK+/v1eIEG9KYmVValF+fFFpTmrxIUYmDk6pBsb8lxceJHFv//Vef1NG6pYpy6auLVO+
	fuvkiSjnuym3pTf5flvrJdiSncvWmVyYvs43J6InKODyOi/DyRoxIpNYqx0uiFpoz89N6lR4
	a8ouWnoisGGvkNBsey/DBX8dF75JyRHm15m/a2O47UYxIxbbtJdKT+4XVRx+O+dDcLvfjdq6
	2a/9W5RYijMSDbWYi4oTAYcwnqW5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/14 15:18, Daniel Drake wrote:
> On Sun, Oct 19, 2014 at 9:32 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> > This patch adds the new clock driver of Exynos4415 SoC based on Cortex-A9
>> > using common clock framework. The CMU (Clock Management Unit) of Exynos4415
>> > controls PLLs(Phase Locked Loops) and generates system clocks for CPU, buses
>> > and function clocks for individual IPs.
>
> There seems to be a lot in common here with other exynos4 variants in
> clk-exynos4.c. Have you considered just adding support for the 4415 in
> the existing driver?

I would rather avoid mixing clock description tables for more SoCs in
clk-exynos4.c. There is quite a few differences between exynos4x12 and
exynos4415 clock controllers, I'm afraid merging exynos4415 support to
clk-exynos4.c would just create more branches and made the code harder
to follow, without much decrease in code size. The clock tree in single
SoC is already complex, without consolidating support for several SoCs
in one unit.

-- 
Regards,
Sylwester
