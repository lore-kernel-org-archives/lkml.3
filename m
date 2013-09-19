Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab3ISEIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 00:08:34 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40896 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab3ISEId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 00:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <1379563520-7221-1-git-send-email-yinghai@kernel.org>
References: <1379563520-7221-1-git-send-email-yinghai@kernel.org>
Date: Thu, 19 Sep 2013 09:38:32 +0530
Message-ID: <CAKohpomt+sASL=2i-v=HSkhOZhbPmnFesEfPoEqSE+WKcCfnmw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 September 2013 09:35, Yinghai Lu <yinghai@kernel.org> wrote:
> System that cpu support intel_pstate, acpi_cpufreq fail to
> load, and udev keep trying until trace get filled up and
> kernel crash.
>
> The root cause is driver return ret from cpufreq_register_driver
> and when some other driver take over before, it would return
> EBUSY, then udev will keep trying...
>
> cpufreq_register_driver should return EEXIST instead.
> then system could boot without appending intel_pstate=disable
> and still use intel_pstate.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
