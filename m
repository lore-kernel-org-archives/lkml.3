Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3AaJGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:06:35 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63242 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3AaJGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:06:24 -0500
Date: Thu, 31 Jan 2013 10:06:11 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/4] cpufreq: ondemand: call dbs_check_cpu only when
 necessary
Message-ID: <20130131090611.GC30667@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
 <1359550803-18577-3-git-send-email-fabio.baltieri@linaro.org>
 <CAKohpok0iDffNM31W2r97Wtq4DR+TdPwYWTAdJH7AyLqHm0UPA@mail.gmail.com>
 <20130130164614.GC30559@balto.lan>
 <CAKohponMezzus0tRW+CdC7wLq1U1pRio5q=g6F845x7iveFCAA@mail.gmail.com>
 <20130131083825.GA30667@balto.lan>
 <CAKohpokR7-P9BarUwW++Exh8RyHUYFHO4V80+zHqcA-zwCOurg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokR7-P9BarUwW++Exh8RyHUYFHO4V80+zHqcA-zwCOurg@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 02:12:29PM +0530, Viresh Kumar wrote:
> On 31 January 2013 14:09, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > Ok, now I see the problem: cdbs->cpu is initialized only on the leader
> > cpu and this is working by coincidence on my system, while
> > cdbs->time_stamp is initialized only on the leader cpu, and that should
> > be correct even when cpu hotplugging as that's reinitialized every time.
> >
> > That's a fix so I'll send a patch just to set ->cpu into the
> > for_each_cpu cycle.
> 
> That's not enough. You need to set ->cpu to j and not policy->cpu as we
> discussed it earlier (params to timer init and exit.).
> 
> And so, we need to get policy->cpu somehow and get its timestamp.

Current code uses ->cpu to track policy->cpu and get the timestamp, I
can modify it to point to the current cpu and use it in timer_init *and*
add a new field just to track leader_cpu but I don't see the benefits.
Am I missing something?

Fabio

-- 
Fabio Baltieri
