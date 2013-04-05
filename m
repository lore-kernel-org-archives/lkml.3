Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161592Ab3DEFNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:13:10 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:40022 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3DEFNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <1365135708-23886-1-git-send-email-nm@ti.com>
References: <1365135708-23886-1-git-send-email-nm@ti.com>
Date: Fri, 5 Apr 2013 10:43:07 +0530
Message-ID: <CAKohpokiLQNp3JffxuKA5JxeL8+F3-2MK_cMv2FzcddOejQA=Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] cpufreq/regulator: Handle regulators that defer probe
 with device tree bindings
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2013 09:51, Nishanth Menon <nm@ti.com> wrote:
> Currently get_regulator returns -EPROBE_DEFER in the case of regulator supply
> which have no device tree node or even if regulator which are depicted in device
> tree node is defering it's registration for valid reasons.
>
> This makes it impossible to use an regulator that registers itself after
> cpufreq-cpu0 probe is complete. The reason for the same is regulator framework
> fails to return appropriate error value when device tree binding is not actually
> present as a node.
>
> Once we fix that, we can then fix cpufreq-cpu0 to make intelligent decisions
> based on return value.
>
> Nishanth Menon (2):
>   regulator: core: return err value for regulator_get if there is no DT
>     binding
>   cpufreq: cpufreq-cpu0: defer probe when regulator is not ready
>
>  drivers/cpufreq/cpufreq-cpu0.c |   20 ++++++++++++++------
>  drivers/regulator/core.c       |    4 ++--
>  2 files changed, 16 insertions(+), 8 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
