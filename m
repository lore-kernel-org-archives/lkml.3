Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaHUDdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 23:33:46 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56205 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaHUDdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 23:33:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Ga=C3=ABl_PORTAY?= <gael.portay@gmail.com>
Subject: Re: [PATCH 3/3] ARM: at91/tclib: mask interruptions at shutdown and probe
Date: Thu, 21 Aug 2014 05:32:59 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <1408486072-19268-1-git-send-email-gael.portay@gmail.com> <1408486072-19268-4-git-send-email-gael.portay@gmail.com>
In-Reply-To: <1408486072-19268-4-git-send-email-gael.portay@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201408210533.00196.arnd@arndb.de>
X-Provags-ID: V02:K0:wLxcYkTwgYu/SRJhI7qRmodtSE9pG1GCbZLSJzl1XR+
 UkPRuDvGSMB6E/jEPaUVA/FUJktN6HzNVTdSqBmT9Ti2lhSk8X
 F/lC7/WxVqt+MnCtw2+b0mk5u6GGLUO8shybKRCQwiSzRKDOx9
 a5hutaOCjN2jsDAbvlXYm0iRpNcm5ZSuDfhduY+7SKlV8sqTTs
 DaMItEvZGDd11M26JkfkskyuvVJTkWbZ1gtB+624rzFlG2AVbb
 0b1XY+wYVvnNPtltZ7GXc65xhcgBWTywrrNGZOuuYP3XTJHKz+
 qo1JPveN2uyzqPE0e9GE1fyXvbPLxboBFslyNZjhpJzaGihoad
 DzVNwOELHfFc3gKxq9ko=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 August 2014, Gaël PORTAY wrote:
> +static void tc_shutdown (struct platform_device *pdev)
> +{
> +       int i;
> +       struct atmel_tc *tc = platform_get_drvdata(pdev);
> +
> +       for (i = 0; i < 3; i++)
> +               __raw_writel(0xff, tc->regs + ATMEL_TC_REG(i, IDR));
> +}

In general, __raw_readl/__raw_writel are not meant to be called by device drivers.

Just use readl/writel by default, or readl_relaxed/writel_relaxed if the code is
performance critical and you are sure it is safe to use them.

	Arnd
