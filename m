Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3ITMjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:39:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40915 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab3ITMjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:39:22 -0400
Date: Fri, 20 Sep 2013 07:38:08 -0500
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
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
Subject: Re: [PATCH 1/3] PM / OPP: rename functions to dev_pm_opp*
Message-ID: <20130920123808.GA22176@kahuna>
References: <1379624632-17356-1-git-send-email-nm@ti.com>
 <1379624632-17356-2-git-send-email-nm@ti.com>
 <CAKohpoku7n6b2dDKD=+3DqG4pHtmWoeXZnAt3EoFRp+rNFofYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpoku7n6b2dDKD=+3DqG4pHtmWoeXZnAt3EoFRp+rNFofYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:44-20130920, Viresh Kumar wrote:
> On 20 September 2013 02:33, Nishanth Menon <nm@ti.com> wrote:
> > opp_get_opp_count
> > opp_find_freq_exact
> > opp_init_cpufreq_table
> > opp_free_cpufreq_table
> 
> The only problem I see is that routines names for few of them are getting
> really long now.. Otherwise not much I could find...
I am open to suggestions if any one feels we can improve this better.

> 
> Though you had following changes, which you could have avoided in this
> hard to review patchset:
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>         new_opp = [-kzalloc(sizeof(struct
> opp),-]{+kzalloc(sizeof(*new_opp),+} GFP_KERNEL);
>         new_opp = [-kmalloc(sizeof(struct
> opp),-]{+kmalloc(sizeof(*new_opp),+} GFP_KERNEL);
> 
> It is almost impossible to catch these with naked eyes for such long
> patches.. I took help of --word-diff though :)
I believe that change was from Patch #2[1]
yes, you are right, I had squashed this patch in to squelch checkpatch
warnings:
CHECK: Prefer kzalloc(sizeof(*new_opp)...) over kzalloc(sizeof(struct
		       dev_pm_opp)...)
#177: FILE: drivers/base/power/opp.c:406:
+	new_opp = kzalloc(sizeof(struct dev_pm_opp), GFP_KERNEL);

CHECK: Prefer kmalloc(sizeof(*new_opp)...) over kmalloc(sizeof(struct
		       dev_pm_opp)...)
#191: FILE: drivers/base/power/opp.c:495:
+	new_opp = kmalloc(sizeof(struct dev_pm_opp), GFP_KERNEL);


I had added a comment:
" Minor checkpatch warning fixes as a result of this change was fixed as
well."

Would you suggest I split the change off to a separate patch or improve
 the comment a little more?
> 
> If no one else sees these as problems then feel free to add my:
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

[1] https://patchwork.kernel.org/patch/2913551/
-- 
Regards,
Nishanth Menon
