Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3IMEXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 00:23:13 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52776 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3IMEXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 00:23:10 -0400
MIME-Version: 1.0
In-Reply-To: <793a5fadad931d04c2adb3a61c64063b7e62d083.1378979483.git.viresh.kumar@linaro.org>
References: <a0cad3326c6a6c8f0517332dd2230edaf67268e7.1378979483.git.viresh.kumar@linaro.org>
	<793a5fadad931d04c2adb3a61c64063b7e62d083.1378979483.git.viresh.kumar@linaro.org>
Date: Fri, 13 Sep 2013 09:53:09 +0530
Message-ID: <CAKohpo=kBvx3-fkmOUzk3PsbGZxicAWD9iJyUBkXYG-1wM_WNA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 15:40, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Some part of this patch was pushed in mainline earlier but was then removed due
> to loopholes in the patch. Those are now fixed and this patch is tested by the
> people who reported these problems.
>
> Whenever we are changing frequency of a cpu, we are calling PRECHANGE and
> POSTCHANGE notifiers. They must be serialized. i.e. PRECHANGE or POSTCHANGE
> shouldn't be called twice contiguously. Also, calls to cpufreq_driver_target()
> or cpufreq_driver->target() must also be serialized. Following examples show why
> this is important:

Adding:

Tested-by: Stephen Warren <swarren@nvidia.com>

Picked from the other thread..
