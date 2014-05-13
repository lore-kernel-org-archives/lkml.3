Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaEMVwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:52:22 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:65014 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaEMVwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <53725FED.7050303@wwwdotorg.org>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
	<1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
	<53725FED.7050303@wwwdotorg.org>
Date: Tue, 13 May 2014 14:52:15 -0700
X-Google-Sender-Auth: e47kpFrXOAi7G7zbOGphrTEZOx4
Message-ID: <CAL1qeaHMcUsqsY75584P6vbzex0FiHc1YtsDKbDj923Hxw5Mkw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 11:09 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/13/2014 08:06 AM, Peter De Schrijver wrote:
>> Add shared and cbus clocks to the Tegra124 clock implementation.
>
>> diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
>
>> +#define TEGRA124_CLK_C2BUS 401
>> +#define TEGRA124_CLK_C3BUS 402
>> +#define TEGRA124_CLK_GR3D_CBUS 403
>> +#define TEGRA124_CLK_GR2D_CBUS 404
> ...
>
> I worry about this a bit. IIUC, these clocks don't actually exist in HW,
> but are more a way of SW applying policy to the clock that do exist in
> HW. As such, I'm not convinced it's a good idea to expose these clock
> IDS to DT, since DT is supposed to represent the HW, and not be
> influenced by internal SW implementation details.

The purpose of these IDs, I believe, is to be used in bindings for consumer
devices so that the driver can get() the shared clock.

> Do any DTs actually need to used these new clock IDs?

AFAIK no driver currently supports the use of these shared clocks, but
they could.
In the chromium kernel, for example, we have devices which require an
"emc" clock
in their bindings that the driver uses to vote on SDRAM frequency.  I
guess we could
avoid specifying these clocks in the DT by creating aliases for them,
but I'm not sure
that's any better.

> I don't think we could actually use these value in e.g. tegra124.dtsi's clocks
> properties, since these clocks don't exist in HW.

The DT IDs are simply used to look up the struct clk corresponding to the ID
in the per-SoC clks array.  They aren't used for indexing into a hardware
register or anything like that, though they happen to currently be assigned so
that they match the corresponding clock's hardware ID.
