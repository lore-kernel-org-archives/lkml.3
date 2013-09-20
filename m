Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3ITHOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 03:14:07 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:36635 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3ITHOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:14:02 -0400
MIME-Version: 1.0
In-Reply-To: <1379624632-17356-2-git-send-email-nm@ti.com>
References: <1379624632-17356-1-git-send-email-nm@ti.com>
	<1379624632-17356-2-git-send-email-nm@ti.com>
Date: Fri, 20 Sep 2013 12:44:00 +0530
Message-ID: <CAKohpoku7n6b2dDKD=+3DqG4pHtmWoeXZnAt3EoFRp+rNFofYA@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: rename functions to dev_pm_opp*
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2013 02:33, Nishanth Menon <nm@ti.com> wrote:
> opp_get_opp_count
> opp_find_freq_exact
> opp_init_cpufreq_table
> opp_free_cpufreq_table

The only problem I see is that routines names for few of them are getting
really long now.. Otherwise not much I could find...

Though you had following changes, which you could have avoided in this
hard to review patchset:

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
        new_opp = [-kzalloc(sizeof(struct
opp),-]{+kzalloc(sizeof(*new_opp),+} GFP_KERNEL);
        new_opp = [-kmalloc(sizeof(struct
opp),-]{+kmalloc(sizeof(*new_opp),+} GFP_KERNEL);

It is almost impossible to catch these with naked eyes for such long
patches.. I took help of --word-diff though :)

If no one else sees these as problems then feel free to add my:
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
