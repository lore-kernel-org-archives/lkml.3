Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab3IZGJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:09:30 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:56794 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3IZGJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:09:28 -0400
MIME-Version: 1.0
In-Reply-To: <52436237.3040500@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<495ffb1175175b0180ca3da96eb5ed72a8280364.1379779777.git.viresh.kumar@linaro.org>
	<52436237.3040500@linaro.org>
Date: Thu, 26 Sep 2013 11:39:28 +0530
Message-ID: <CAKohpokBPD35pBpCt-x0KGNvy3hxmYGPxXpSBJZcgo7ir8L3hA@mail.gmail.com>
Subject: Re: [PATCH 18/21] cpuidle: don't call poll_idle_init() for every cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 03:52, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> On 09/22/2013 03:21 AM, Viresh Kumar wrote:
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

This deserved a log, sorry for missing that :(

> The optimization sounds good but IMHO if we can move this state out of
> the cpuidle common framework that would be nicer.
>
> The poll_idle is only applicable for x86 (acpi_driver and intel_idle),
> hence I suggest we move this state to these drivers, that will cleanup
> the framework code and will remove index shift macro
> CPUIDLE_DRIVER_STATE_START which IMHO is weid and prone-to-error.

Lets see what X86 folks have to say about it and then we can do it..
Btw, wouldn't that add some code duplication in those two drivers?
