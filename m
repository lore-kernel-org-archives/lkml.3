Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3LROjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:39:44 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:45278 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3LROjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:39:42 -0500
MIME-Version: 1.0
In-Reply-To: <52B187F5.7020105@nvidia.com>
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
	<1386229462-3474-3-git-send-email-bilhuang@nvidia.com>
	<CAKohponns4B+BPPum3EN6EuXx6U+6MzOa50gMdR1BNBtxMNf0Q@mail.gmail.com>
	<52B02D04.4050905@nvidia.com>
	<CAKohpom0n8P8goQnsgBnWJwyqCVv_FRX3xKvO1yFW0VUMpMW8w@mail.gmail.com>
	<52B187F5.7020105@nvidia.com>
Date: Wed, 18 Dec 2013 20:09:41 +0530
Message-ID: <CAKohpokwhYC4FGnhpZPOGuJ2AM_7vygNk+3S+VpA_eXAexQX7g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: bilhuang <bilhuang@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 December 2013 17:03, bilhuang <bilhuang@nvidia.com> wrote:
> cpufreq-cpu0 driver will call regulator_set_voltage_tol() directly according
> to the pre-defined OPP freq/volt pairs, the regulator drivers could be
> shared by other SoC so is not suitable to handle this, or do I
> misunderstand?

In case regulator's driver is shared, then you can probably add another
virtual regulator for CPU which would have the special code you want.
