Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbbATCAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:00:25 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:52700 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbATCAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:00:23 -0500
MIME-Version: 1.0
In-Reply-To: <20150119141224.GF23778@ulmo.nvidia.com>
References: <1421319545-23920-1-git-send-email-digetx@gmail.com>
 <1421319545-23920-2-git-send-email-digetx@gmail.com> <20150119141224.GF23778@ulmo.nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 20 Jan 2015 10:59:56 +0900
Message-ID: <CAAVeFuKX_EL_b8HsHSa8g67QYZTE6YeNY9n4GCnsB3G2iJZgBQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra20: Store CPU "resettable" status in IRAM
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Dmitry Osipenko <digetx@gmail.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 11:12 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Thu, Jan 15, 2015 at 01:58:57PM +0300, Dmitry Osipenko wrote:
>> Commit 7232398abc6a ("ARM: tegra: Convert PMC to a driver") changed tegra_resume()
>> location storing from late to early and, as a result, broke suspend on Tegra20.
>> PMC scratch register 41 is used by tegra LP1 resume code for retrieving stored
>> physical memory address of common resume function and in the same time used by
>> tegra20_cpu_shutdown() (shared by Tegra20 cpuidle driver and platform SMP code),
>> which is storing CPU1 "resettable" status. It implies strict order of scratch
>> register usage, otherwise resume function address is lost on Tegra20 after
>> disabling non-boot CPU's on suspend. Fix it by storing "resettable" status in
>> IRAM instead of PMC scratch register.
>>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> Fixes: 7232398abc6a (ARM: tegra: Convert PMC to a driver)
>> Cc: <stable@vger.kernel.org> # v3.17+
>> ---
>>  arch/arm/mach-tegra/cpuidle-tegra20.c |  5 ++---
>>  arch/arm/mach-tegra/reset-handler.S   | 10 +++++++---
>>  arch/arm/mach-tegra/reset.h           |  4 ++++
>>  arch/arm/mach-tegra/sleep-tegra20.S   | 37 ++++++++++++++++++++---------------
>>  arch/arm/mach-tegra/sleep.h           |  4 ++++
>>  5 files changed, 38 insertions(+), 22 deletions(-)
>
> I'm leaning towards applying this. Stephen, Alex, Peter: any objections?

None from me ; but I am not qualified to give an valuable opinion on
this part of the code.
