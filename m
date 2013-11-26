Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3KZCQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:16:15 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:40539 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3KZCQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <5293C16D.80605@ti.com>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
	<e4bc55fac6bc68694e9905cc3cc6844173b64925.1385118256.git.viresh.kumar@linaro.org>
	<5293C16D.80605@ti.com>
Date: Tue, 26 Nov 2013 07:46:11 +0530
Message-ID: <CAKohpokAL9iTN8KSONwBS1JHBg93RyBS6nJVBruxddjO-UvYcg@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] cpufreq: suspend governors on system suspend/hibernate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, jinchoi@broadcom.com,
        Sebastian Capella <sebastian.capella@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2013 03:00, Nishanth Menon <nm@ti.com> wrote:
> yes, this seems to work for me as well.
> http://pastebin.mozilla.org/3670909 - no cpufreq attempts to
> transition were triggered.

Ahh.. Thanks for confirming..
But we still can't work with noirq handlers as there are platforms
which want to change frequency before going into suspend and
so we need to do this from dpm_suspend() :)

Thanks for trying.

--
viresh
