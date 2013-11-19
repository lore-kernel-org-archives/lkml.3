Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3KSOWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:22:18 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:48891 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3KSOWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:22:15 -0500
MIME-Version: 1.0
In-Reply-To: <1384850540.3381.6.camel@linaro1.home>
References: <b0a2e5d26be45d1d2853940d318d50415db48f6f.1384839287.git.viresh.kumar@linaro.org>
	<1384850540.3381.6.camel@linaro1.home>
Date: Tue, 19 Nov 2013 19:52:14 +0530
Message-ID: <CAKohpomZeD-1gsh-u_wyabaYLoqm3A=cyUNyZDMmzE3_fKA8-g@mail.gmail.com>
Subject: Re: [PATCH] cpufreq/stats: Add "unknown" frequency field in stats tables
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2013 14:12, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
> I'm wondering if this would break any user-side code parsing this output
> and does that matter? (E.g. powertop will end up doing strtoull on
> "unknown" and get zero as the frequency.)  Would omitting 'unknown' if
> the time is zero be safer in this repect? Possibly not, inconsistency is
> probably worse than change.

We wouldn't know about this on bootup all the time. I thought of doing
this only when an invalid frequency is configured at boot. Because after
that cpufreq will never configure any freq out of freq-table.

But in case of suspend/resume control again goes to bootloaders and
they might end up configuring unknown freq again. And we aren't
allocating these data structures on suspend resume but only during
system boot.

Even if powertop reads it zero then also it isn't that bad.. because the
other option we had was to mark it zero or -1 (uint max).. But unknown
looks better for readability..

--
viresh
