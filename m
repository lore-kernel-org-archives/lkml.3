Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3AaJML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:12:11 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:40363 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3AaJMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:12:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130131090611.GC30667@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
	<1359550803-18577-3-git-send-email-fabio.baltieri@linaro.org>
	<CAKohpok0iDffNM31W2r97Wtq4DR+TdPwYWTAdJH7AyLqHm0UPA@mail.gmail.com>
	<20130130164614.GC30559@balto.lan>
	<CAKohponMezzus0tRW+CdC7wLq1U1pRio5q=g6F845x7iveFCAA@mail.gmail.com>
	<20130131083825.GA30667@balto.lan>
	<CAKohpokR7-P9BarUwW++Exh8RyHUYFHO4V80+zHqcA-zwCOurg@mail.gmail.com>
	<20130131090611.GC30667@balto.lan>
Date: Thu, 31 Jan 2013 14:41:51 +0530
Message-ID: <CAKohpomep=XW2ALOOQe3NLCFjQXCuN9UstuQTkqw8+ZRuNF8uQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] cpufreq: ondemand: call dbs_check_cpu only when necessary
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 14:36, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> Current code uses ->cpu to track policy->cpu and get the timestamp, I
> can modify it to point to the current cpu and use it in timer_init *and*
> add a new field just to track leader_cpu but I don't see the benefits.
> Am I missing something?

Current code doesn't use cdbs->cpu for any cpu leaving the leader. So, we
can use that field to keep local cpus. And for any cpu we can get the updated
leader cpu with following:

j_cdbs->cur_policy->cpu :)
