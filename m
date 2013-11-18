Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3KRPnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:43:23 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48692 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3KRPnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:43:15 -0500
MIME-Version: 1.0
In-Reply-To: <528A3373.7040205@ti.com>
References: <1384561243-30391-1-git-send-email-nm@ti.com>
	<1423628.uM8DtnYzDe@vostro.rjw.lan>
	<5287010F.9000508@linaro.org>
	<528A2D59.3080001@ti.com>
	<CAKohpokzk2Zr7G+GV9d9Bc73WJHNMg01dfAJcxbwCGKFt9BpOw@mail.gmail.com>
	<528A3373.7040205@ti.com>
Date: Mon, 18 Nov 2013 21:13:14 +0530
Message-ID: <CAKohponyFja18pqn5UL9bbtf_M4twWEyL3YqDGX5dgpdeRnJ_A@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: stats: Do not populate stats when policy->cur
 has no exact match
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>,
        Tobias Diedrich <ranma+xen@tdiedrich.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2013 21:04, Nishanth Menon <nm@ti.com> wrote:
> depends on how we look at it.. if we consider freq_table as a list of
> valid frequencies, anything that is not in there is an invalid entry.

Partly correct. Yes freq table has a list of valid frequencies, but normally
we just build a table of definite length which will cover frequencies of
all ranges.. Our plls allow us to configure other frequencies too and
they are valid too.. So, we really can't call that invalid.. Though they
must be called out of range? or something better?

> why should stat support it when freq_table is enforced by cpufreq layer?

We are not supporting them, and so had a single entry for them. It is
just to show to user that we are actually running on some freq outside
of table. You better check if that's fine for your system or not.

> :) -> https://patchwork.kernel.org/patch/3192211/ shows how confused
> my git am  feels ;)

I am surprised to see what patchwork has done to my diff :) .. whereas
lkml shows it correctly..

https://lkml.org/lkml/2013/11/16/3

Because I haven't created a commit, it was only diff and git am couldn't
get this fixed.. So either patch -p1 < mail would have done it or maybe
its better if I paste commits..
