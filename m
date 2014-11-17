Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaKQNDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:03:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58796 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaKQNDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:03:03 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-13-5469f2041219
Date: Mon, 17 Nov 2014 14:02:45 +0100
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
Message-id: <20141117140245.51837653@amdc2363>
In-reply-to: <20141117120105.GH25699@ulmo>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
 <5465DDC5.6090301@kapsi.fi> <20141117114341.GF25699@ulmo>
 <20141117125013.3493a3a1@amdc2363> <20141117120105.GH25699@ulmo>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQV2WT5khBlNuqllsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbXF51xw2i8+9RxgtOr/MYrO4/eEAs8WDq9PYLJ48
	7GOzeHWwjcXi5655LBbHTsxgdRDweLLpIqPHzll32T0W73nJ5HHp3B9mj3XT3jJ7HJh8jtWj
	t/kdm8e3MxNZPPq2rGL0ePpjL7PH501yHhvnhgbwRHHZpKTmZJalFunbJXBl/N98lbWgj6/i
	yK4NrA2MndxdjBwcEgImEl+eGXcxcgKZYhIX7q1nA7GFBKYzSlyYl93FyAVk/2KUePljAhNI
	gkVAVeL7swnsIDabgJ7E57tPweIiAroS/0+/YQFpYBboZpVYeOEWC0hCWCBe4s73S2ANvEAN
	TZvbmUFsTgEtiTeLJ0Jt288kcfZvIIjNLyAp0f7vBzPERXYS5z5tgOoVlPgx+R7YTGag3s3b
	mlghbHmJzWveMk9gFJyFpGwWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO
	y2fSOxhXNVgcYhTgYFTi4d2RnRkixJpYVlyZe4hRgoNZSYQ35iJQiDclsbIqtSg/vqg0J7X4
	EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA+PqUzaapsvMH6xQXfC07PTfv055f6I+
	7szOy5L3VBWrO7hL7cme6xPZJj1LyltzILjj2F3+JIuytM4F9T5PFeSWTDP4VrzoWnWMui6b
	47Vj33ZkbagxePJkiqeRkIR0EFeEXK7KkYfzZue/8JhZKvP3C88UuW3BLx1vVxQsmL3RoKfN
	8qzigitKLMUZiYZazEXFiQCE2C03xwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

> On Mon, Nov 17, 2014 at 12:50:13PM +0100, Lukasz Majewski wrote:
> > Hi Thierry,
> > 
> > > On Fri, Nov 14, 2014 at 12:47:33PM +0200, Mikko Perttunen wrote:
> > > > Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> > > > 
> > > > One potential issue I can see is that if the cpufreq driver
> > > > fails to probe then you'll never get the thermal driver either.
> > > > For example, Tegra124 currently has no cpufreq driver, so if
> > > > CONFIG_CPU_THERMAL was enabled, then the soctherm driver would
> > > > never be able to probe. But I don't really have a solution for
> > > > this either.
> > > 
> > > It doesn't seem like there's any code whatsoever to deal with
> > > cpufreq within the soctherm driver, so deferring probe based on
> > > something we're not using anyway seems rather useless.
> > 
> > So, If I understood you correctly - this patch is not needed in the 
> > /tegra_soctherm.c:[tegra_defconfig] driver and can be safely
> > omitted in v2 of this driver.
> 
> What I'm saying is that I don't think doing this mass conversion
> wholesale is useful since none of the drivers register a cooling
> device based on cpufreq. In other words: if you're not going to use a
> feature there's no use testing for it.
> 

It seems, like one option here would be to add deferred proble to
cpufreq_cooling_register() or check which driver in its thermal probe
is calling cpufreq_cooling_register() function.

The latter option explains why in the imx_thermal.c file we check for
deferred probe without #ifdefs for CONFIG_CPU_THERMAL.

If no objections, I would like to stick to the code already available
in imx_thermal.c.

> Thierry

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
