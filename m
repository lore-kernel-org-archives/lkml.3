Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaGOLCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:02:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23420 "EHLO
	mailout1.samsung.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbaGOLB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:01:59 -0400
X-AuditID: cbfee61b-f79f86d00000144c-11-53c509f48a8c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Daniel Drake <drake@endlessm.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v3 0/4] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
Date: Tue, 15 Jul 2014 13:00:30 +0200
Message-id: <12227526.hKTn2dDzxP@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAD8Lp46mp-tHcwGpFd0YHRDE4pKWDoPpUvu-Y0QzxSi-jnYtWg@mail.gmail.com>
References: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
 <CAD8Lp46mp-tHcwGpFd0YHRDE4pKWDoPpUvu-Y0QzxSi-jnYtWg@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xoO4XzqPBBicPqlrM+yxr8Wj+Y2aL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PVY9D3L4861PWwem5fUe9z+95jZY8vVdhaPvi2rGD0+b5ILYI/isklJzcksSy3St0vg
	ylj5qoG54ChPxY5Fu9kbGP9xdjFyckgImEhs3fqACcIWk7hwbz1bFyMXh5DAdEaJT39PsUM4
	LUwS++/sYgOpYhOwkpjYvooRxBYRUJX4tbyZFaSIWeAus0TT833MIAlhgQyJDfMWsYPYLEBF
	TycuZQGxeQW0JDY/eAE2SFTAU2LH9pVgNqdAsMTzVVdZIbb1M0p8WPqTEaJBUOLH5HtgzcwC
	8hL79k9lhbDVJSbNW8Q8gVFgFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOGaeSe9gXNVgcYhRgINRiYdX4t3hYCHWxLLiytxDjBIczEoivPX/jgQL8aYkVlalFuXH
	F5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYDRMqirJOry2ZWXSq/stF+7M
	+fz0U+tGR4s79r7HgrdPXZ0b2PL4tI9WZ9RbicMdD4JbgmvT7eVXTNg2by/jZ/F5dfFem38X
	6jA/frWpmzf99AfeRZPzJG/vOeWg8eHltiuNYasKXDNW1vcvm1Dxurr1p9prOZ9Vq67KrZ3/
	ol8upEZdM/DoqilKLMUZiYZazEXFiQBg/pFHlQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 14, 2014 04:41:25 PM Daniel Drake wrote:
> Hi Bartlomiej,

Hi,

> On Wed, Jul 9, 2014 at 6:17 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > This patch series adds support for AFTR idle mode on boards with
> > secure firmware enabled and allows EXYNOS cpuidle driver usage on
> > Exynos4x12 SoCs.
> >
> > It has been tested on Trats2 board (using Exynos4412 SoC with secure
> > firmware enabled) on which AFTR mode reduces power consumption by ~12%
> > when EXYNOS cpuidle driver is enabled (in both cases the default
> > exynos_defconfig config is used and CPU1-3 are offlined).
> 
> Thanks for this, I have tested it on ODROID-U2.
> 
> I don't have any equipment to measure the power usage, but after
> offlining CPUs 1,2,3 via sysfs "online" file, a printk I added
> confirms that the system is going to enter aftr mode, and system
> stability seems as good as ever.

Thank you for testing!

> Is there any automatic way that the cpus should be offlined, or is the
> intention that it must be done "by hand" like this?

AFAIK Android kernel disables unused CPUs by itself.  There is also
ongoing work on Exynos coupled cpuidle driver for upstream kernels
which will handle offlining of CPUs for AFTR mode transparently to
the kernel (currently only Exynos4210 SoC is supported by the driver
posted by Daniel Lezcano, we are working on Exynos3250 SoC support
and once it is done we might try to also do Exynos4x12 SoCs version).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

