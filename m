Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaGKQdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:33:51 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:38206 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaGKQds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:33:48 -0400
MIME-Version: 1.0
In-Reply-To: <53C002BE.90805@nvidia.com>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
	<1405028569-14253-13-git-send-email-ttynkkynen@nvidia.com>
	<CAKohpom9ORXFiUU4=V+CxgN0ZOFLMEhEjHiU8HsYUYDybNXgHQ@mail.gmail.com>
	<20140711091207.GY23218@tbergstrom-lnx.Nvidia.com>
	<20140711145735.GB6523@ulmo>
	<53BFFEAD.7000405@nvidia.com>
	<20140711151501.GA25810@ulmo>
	<53C002BE.90805@nvidia.com>
Date: Fri, 11 Jul 2014 09:33:47 -0700
X-Google-Sender-Auth: M_ArMAqHvzSgRBTQs2Iqsba8QC4
Message-ID: <CAL1qeaGOW8U6B0rLvFZKLzoZviMZwWJcfmXdmgZA329Mmvy_Ow@mail.gmail.com>
Subject: Re: [PATCH 12/13] cpufreq: Add cpufreq driver for Tegra124
From: Andrew Bresticker <abrestic@chromium.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 8:29 AM, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
>
> On the hardware level, the two I2C controllers sharing the same pins
> have knowledge of each other and won't start transmitting if the bus
> is busy (something different from the usual I2C arbitration, that is).
> I guess on the kernel side there could be a problem if the voltage register
> is marked cached in the PMIC driver's regmap.

Yeah, in our tree we have a hack to disable regcache for SD0_VOLTAGE.
Other than the value reported to userspace being wrong, leaving it as
cacheable shouldn't be an issue if no other drivers try to read/write
that register.
