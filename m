Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3LWFGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:06:52 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:61620 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3LWFGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:06:50 -0500
MIME-Version: 1.0
In-Reply-To: <52B4707F.4040303@wwwdotorg.org>
References: <1387451926-21373-1-git-send-email-bilhuang@nvidia.com>
	<CAKohpomCPJYd+d_NnM9gxwQ7bH6C6=iLxbiWZbfNcjZ8Bi+2wA@mail.gmail.com>
	<52B41B18.30302@nvidia.com>
	<CAKohpontQwTc4KP7XMvtkvS2sQTyF+ngXnXfbJ1ev+MLEp-H0g@mail.gmail.com>
	<52B41F1B.3030005@nvidia.com>
	<52B4707F.4040303@wwwdotorg.org>
Date: Mon, 23 Dec 2013 10:36:49 +0530
Message-ID: <CAKohpokwO3BgXr9Le02bNo=771saWuDe2H=fgQzcboRWxwVzOg@mail.gmail.com>
Subject: Re: [PATCH v5 1/1] cpufreq: tegra: Re-model Tegra20 cpufreq driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: bilhuang <bilhuang@nvidia.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccc'ing Grant and Rob as well.

On 20 December 2013 21:59, Stephen Warren <swarren@wwwdotorg.org> wrote:
> No, I definitely don't agree here. The rules for arch/arm64 are: no
> platform-specific code. We should immediately start planning for that.
> If this means renaming the file that creates the virtual device from
> tegra-cpufreq.c to something else, so be it, but we shouldn't go
> backwards and push stuff into the arch directories.

I don't mind doing this now as well if it is generic enough. I wasn't sure
if you guys wanted to take it on now..

@Bill: So, please create a separate commit for creating such file which
would create a virtual device for probing cpufreq drivers with name picked
from root-node. Compilation of such a file should be configurable but if
it is compiled, then it shouldn't cause any problems if that device isn't
used, for multiplatform kernels specially..

Probably then you can widen the scope of your patchset by modifying
some of the existing drivers which require a device to get cpufreq
driver probed. Currently they are all making such a device from
their arch/ stuff.

I am not sure about the location of such file. Should this be placed in DT
code somewhere or kept in cpufreq? Rob/Grant ??

--
viresh
