Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3HLWhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:37:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40121 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab3HLWhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:37:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        Mikael Starvik <starvik@axis.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Steven Miao <realmz6@gmail.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 00/31] CPUFreq: Implement light weight ->target(): for 3.13
Date: Tue, 13 Aug 2013 00:47:45 +0200
Message-ID: <1391342.M2Jbj3t5qy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 12, 2013 11:18:36 PM Viresh Kumar wrote:
> Currently prototype of cpufreq_drivers target routines is:
> 
> int target(struct cpufreq_policy *policy, unsigned int target_freq,
> 	unsigned int relation);
> 
> And most of the drivers call cpufreq_frequency_table_target() to get a valid
> index of their frequency table which is closest to the target_freq. And they
> don't use target_freq and relation after it.
> 
> So, it makes sense to just do this work in cpufreq core before calling
> cpufreq_frequency_table_target() and simply pass index instead. But this can be
> done only with drivers which expose their frequency table with cpufreq core. For
> others we need to stick with the old prototype of target() until those drivers
> are converted to expose frequency tables.
> 
> So, in order not to break those special drivers first patch renames ->target() to
> ->target_old() and the following patches will define the new prototype and
> convert existing drivers one by one.

Super-ugly.

Please just keep the old .target() as is, add a new callback and switch the
suitable drivers to using it.  You may call the new one .target_index() or
something along these lines.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
