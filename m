Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaKQLua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:50:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52505 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaKQLu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:50:26 -0500
X-AuditID: cbfee61a-f79c06d000004e71-c5-5469e0ff7f00
Date: Mon, 17 Nov 2014 12:50:13 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Eduardo Valentin <edubezval@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] thermal:cpu cooling:tegra: Provide deferred probing
 for tegra driver
Message-id: <20141117125013.3493a3a1@amdc2363>
In-reply-to: <20141117114341.GF25699@ulmo>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
 <5465DDC5.6090301@kapsi.fi> <20141117114341.GF25699@ulmo>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQd3/DzJDDFY2KVpsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbXF51xw2i8+9RxgtOr/MYrO4/eEAs8WDq9PYLJ48
	7GOzeHWwjcXi5655LBbHTsxgdRDweLLpIqPHzll32T0W73nJ5HHp3B9mj3XT3jJ7HJh8jtWj
	t/kdm8e3MxNZPPq2rGL0ePpjL7PH501yHhvnhgbwRHHZpKTmZJalFunbJXBltJx9yF5wkaPi
	1/aXTA2Mr9m6GDk4JARMJC5NU+xi5AQyxSQu3FvPBmILCUxnlDj6zAjC/sUo8fBNKojNIqAq
	sebrFUYQm01AT+Lz3adMILaIgK7E/9NvWLoYuTiYBbpZJRZeuMUCkhAWiJe48/0SO4jNC9TQ
	Pe01M4jNKaAlceLiamaQBiGBP4wSW+9MAZvELyAp0f7vBzPERXYS5z5tgGoWlPgx+R7YUGag
	5s3bmlghbHmJzWveMk9gFJyFpGwWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAiOy2dSOxhXNlgcYhTgYFTi4d2RnRkixJpYVlyZe4hRgoNZSYQ35iJQiDclsbIqtSg/vqg0
	J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA2PoL4aEOPaA4uVfE94oneH8vf3T
	5/4nvR//PVsol/Na7eLs36zT1HimJr4R5n+UucrHcfet7tfJ6zna/987Zz6dZeWP27f7jfN7
	z0y2vrN5+sWw643f1zh6fVY+nhutr/xHMtRiz6nn18RU34f41nnPfHnw0rRXe4NvVswWyH/U
	J+L8OMns/G8dJZbijERDLeai4kQA1s0KnccCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

> On Fri, Nov 14, 2014 at 12:47:33PM +0200, Mikko Perttunen wrote:
> > Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> > 
> > One potential issue I can see is that if the cpufreq driver fails
> > to probe then you'll never get the thermal driver either. For
> > example, Tegra124 currently has no cpufreq driver, so if
> > CONFIG_CPU_THERMAL was enabled, then the soctherm driver would
> > never be able to probe. But I don't really have a solution for this
> > either.
> 
> It doesn't seem like there's any code whatsoever to deal with cpufreq
> within the soctherm driver, so deferring probe based on something
> we're not using anyway seems rather useless.

So, If I understood you correctly - this patch is not needed in the 
/tegra_soctherm.c:[tegra_defconfig] driver and can be safely omitted in
v2 of this driver.

Please note that I'm not aware of Tegra specific use cases and hence
I've prepared fixes for all potential candidates.

> 
> Thierry

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
