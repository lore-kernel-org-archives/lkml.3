Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaLCLYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:24:44 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54794 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaLCLYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:24:42 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-c9-547ef2f78d74
Message-id: <547EF2EA.70309@samsung.com>
Date: Wed, 03 Dec 2014 12:24:26 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-media@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kamil Debski <k.debski@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
References: <4139875.fkJ48z9AaU@vostro.rjw.lan>
In-reply-to: <4139875.fkJ48z9AaU@vostro.rjw.lan>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xq7rfP9WFGKzbyWzx4/UFNoveBVfZ
	LM42vWG3uLxrDptFz4atrBafe48wWsw4v4/J4uI6eYu7906wWJw5fYnVgcuj/6+Bx5ar7Swe
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlXG7aSlTwTKeinsdu9gaGN9wdjFyckgImEgcbPrP
	DmGLSVy4t56ti5GLQ0hgKaPEqTnzWSCcT4wS+w5OZwap4hXQkHj6ZCUTiM0ioCpx+OhLsG42
	AUOJ3qN9jCC2qECExMm7e9gh6gUlfky+BzSIg0NEwENi+/pqkDCzwF0micNXgkDCwgKeEpf/
	64OEhQT0JRa9eMMKYnMKGEhMmL6eEaSEWUBdYsqUXIhOeYnNa94yT2AUmIVk/iyEqllIqhYw
	Mq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAn3LzsYFx+zOsQowMGoxMOrMKUuRIg1say4
	MvcQowQHs5IIb8MboBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGiA+q/5Q+hC31qv7U98fz9oHW
	Q6K3zsU/W/FudsOl5yXluhk7ld1rzivNe1e5auNvq6eGQp8Plulr3pjHbcC+TqN8cyWT/h8V
	OTmpzWJMp5Kkzy55eTyjbu+ckiDx64VMfSE/+yKyE0yXcEyw7J8ub/VPYu6vr7vOb1p4gXWF
	YmHj5PLoi5f6lViKMxINtZiLihMB6I1DeFUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/14 03:13, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> The alternative of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME may be
> replaced with CONFIG_PM too.
> 
> Make these changes everywhere under drivers/media/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

I'm fine with this being merged through linux-pm as far as the exynos/s5p
drivers are concerned.

> ---
>  drivers/media/platform/coda/coda-common.c       |    4 ++--
>  drivers/media/platform/exynos4-is/fimc-core.c   |    6 +++---
>  drivers/media/platform/exynos4-is/fimc-is-i2c.c |    2 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c   |    2 +-
>  drivers/media/platform/exynos4-is/mipi-csis.c   |    2 +-
>  drivers/media/platform/s5p-jpeg/jpeg-core.c     |    4 ++--
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |   10 ++++------
>  8 files changed, 15 insertions(+), 17 deletions(-)

--
Regards,
Sylwester
