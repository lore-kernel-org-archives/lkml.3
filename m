Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039Ab3LIQfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:35:00 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30017 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab3LIQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:34:57 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-1d-52a5f12f53b8
From: Tomasz Figa <t.figa@samsung.com>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>, Dave.Martin@arm.com,
        nicolas.pitre@linaro.org, tomasz.figa@gmail.com
Subject: Re: [PATCH v4 2/4] clk: exynos5410: register clocks using common clock
 framework
Date: Mon, 09 Dec 2013 17:34:44 +0100
Message-id: <1914850.6CAa0SzDWP@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1385456288-20398-3-git-send-email-v.tyrtov@samsung.com>
References: <1385456288-20398-1-git-send-email-v.tyrtov@samsung.com>
 <1385456288-20398-3-git-send-email-v.tyrtov@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xq7r6H5cGGZyaI2sxad0BJot5n2Ut
	mubuYbSYf+Qcq8X/R69ZLc69Wslo0bvgKpvFpsfXWC0Wti1hsbi8aw6bxYzz+5gsbl/mtVh6
	/SKTxdMJF9ksPj37x24xYfpaFovDK4CmrXs5ncViy88ORotXB9tYLNY/P8VosXnTVGaLVbv+
	MFpMnfGD3UHCY828NYweLc09bB4LPl9h9/i76gWzx85Zd9k9Vi7/wubxavVMVo871/awebw7
	d47dY/OSeo9X11g8+rasYvTYfm0es8fnTXIeG+eGBvBHcdmkpOZklqUW6dslcGVcPLWAsWAe
	Z8XGlm1sDYy72LsYOTkkBEwkHn9bwQhhi0lcuLeerYuRi0NIYCmjxN7/V5ggnC4midWNu1hB
	qtgE1CQ+NzxiA7FFBHQkVr+7AGYzC2xjk7jTqg1iCwtES7x6uJ4ZxGYRUJX4ur8frJdXQFOi
	/24jWJxfQF3i3banTCC2qICbxIt9W8Au4hRwldj4rQvsIiGBeon+OYuhegUlfky+xwKxS15i
	3/6prBC2lsT6nceZJjAKzkJSNgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525i
	hKSArzsYlx6zOsQowMGoxMMbwLw0SIg1say4MvcQowQHs5IIb8NroBBvSmJlVWpRfnxRaU5q
	8SFGJg5OqQZGjh/aeq8XfdTJDF0jdP6oE5d89v8z7cFSEt+iK5ysNq5QZ56w+u0/aUXvlQc1
	HObN912yhfHzF/NvDzImhpxY8GrDupa1R4NlNi/Jss2er2eXMs181p8Qo1Jjgey/mTJOCR/u
	LShl5tn8UMLqcpOUqfQMgbzYj8/inAMFLuXnnj9nM6kr5Y+MEktxRqKhFnNRcSIAsQa0rd8C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vyacheslav, Tarek,

On Tuesday 26 of November 2013 12:58:06 Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> The EXYNOS5410 clocks are statically listed and registered
> using the Samsung specific common clock helper functions.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  .../devicetree/bindings/clock/exynos5410-clock.txt |  54 +++++
>  drivers/clk/samsung/Makefile                       |   1 +
>  drivers/clk/samsung/clk-exynos5410.c               | 239 +++++++++++++++++++++
>  include/dt-bindings/clock/exynos5410.h             |  32 +++
>  4 files changed, 326 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>  create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>  create mode 100644 include/dt-bindings/clock/exynos5410.h

Acked-by: Tomasz Figa <t.figa@samsung.com>

This should go through Samsung tree, I guess, since it's a dependency
of other patches in this series and doesn't depend on any things from
clock tree. Mike, Kukjin, are you okay with this?

Best regards,
Tomasz

