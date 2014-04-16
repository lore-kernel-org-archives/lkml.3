Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbaDPUYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:24:30 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:39375 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaDPUY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <534EAD91.90704@wwwdotorg.org>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
	<1397526163-20126-5-git-send-email-abrestic@chromium.org>
	<CAL1qeaGGSs5fpqrKWA4u4+RXRy9Ko2pN=s9QQdbXAfLG3ujR8g@mail.gmail.com>
	<534EAD91.90704@wwwdotorg.org>
Date: Wed, 16 Apr 2014 13:24:25 -0700
X-Google-Sender-Auth: akJMw8qJ12puDj0SfdoZWzaRzCQ
Message-ID: <CAL1qeaENYazDf6cuWsFLgJcsAPTU9D4nz1dPr3Jva_++Po_mrw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: tegra: fix Venice2 VQMMC regulators
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 9:19 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/15/2014 06:29 PM, Andrew Bresticker wrote:
>>>         sdhci@0,700b0600 {
>>>                 status = "okay";
>>>                 bus-width = <8>;
>>> +               vqmmc-supply = <&vddio_1v8>;
>>
>> It turns out this bit isn't needed as the initialization failures are
>> instead due to +3V3_RUN toggling, which Stephen has fixed:
>> http://patchwork.ozlabs.org/patch/339386/
>
> Indeed, if I apply patches 1, 2, and 4 from this series, revert the hunk
> above, apply my Venice2 regulator patch, and finally apply your AS3722
> regulator GPIO patch, then everything works fine for me:-)

Great, I'll fix up and resend without patch 3 as it looks like that
will need some more work.
