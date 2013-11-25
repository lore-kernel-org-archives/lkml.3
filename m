Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3KYE2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 23:28:33 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63796 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3KYE2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 23:28:30 -0500
MIME-Version: 1.0
In-Reply-To: <2065978.h16hV1Cgky@vostro.rjw.lan>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
	<CAKohpo=RWi1nRUJq4qx8K+Y7swMDaqwEOH24-KfBCMgdbW=hMQ@mail.gmail.com>
	<528FB2EC.2020202@wwwdotorg.org>
	<2065978.h16hV1Cgky@vostro.rjw.lan>
Date: Mon, 25 Nov 2013 09:58:29 +0530
Message-ID: <CAKohpomEL8aU_ETaHFG_G8mhYMZc6M6x7i4m+McozP=i7Fzz5A@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] cpufreq: Change freq before suspending governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Kukjin Kim <kgene@kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2013 03:02, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> Viresh, maybe make it possible for the cpufreq driver to provide suspend/resume
> callbacks to be executed by cpufreq_suspend() and cpufreq_resume() introduced
> by [1/2]?  Then Tegra could set the frequencies to what it wants from there
> before the governors are stopped.

Giving cpufreq-drivers a chance to do whatever they want looks to be
correct. So, maybe prepare() or suspend_prepare() for them can be
implemented.

Though I would still go for a generic function in core, which can be
just  reused by samsung and tegra to set cores to specific frequencies.

--
viresh
