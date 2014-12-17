Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaLQEm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:42:29 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35892 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaLQEm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:42:28 -0500
MIME-Version: 1.0
In-Reply-To: <1418771379-24369-1-git-send-email-dtor@chromium.org>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>
Date: Wed, 17 Dec 2014 10:12:27 +0530
Message-ID: <CAKohpo=bQCR+kOmMaMuQM=7tnbuKzM8XEtmnLbuRiA4C=jCxDQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Allow cpufreq-dt to defer probe if OPP table is not ready
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2014 at 04:39, Dmitry Torokhov <dtor@chromium.org> wrote:
> Note that I am not happy with OPP code: dev_pm_opp_init_cpufreq_table() is
> wrong in it's assumption that taking RCU lock will guarantee that number of
> OPPs will not change - we can remove OPP from list just fine, and then
> initialization will fail. I also think that we shoudl change API so users should
> get a reference to their OPP table and then pass opaque dev_opp pointer to
> accessor APIs instead of re-scanning the global list over and over and over.

Yeah, agree for both of them..
