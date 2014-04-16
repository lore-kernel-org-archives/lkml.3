Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbaDPQTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:19:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44537 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbaDPQTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:19:33 -0400
Message-ID: <534EAD91.90704@wwwdotorg.org>
Date: Wed, 16 Apr 2014 10:19:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ARM: tegra: fix Venice2 VQMMC regulators
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>	<1397526163-20126-5-git-send-email-abrestic@chromium.org> <CAL1qeaGGSs5fpqrKWA4u4+RXRy9Ko2pN=s9QQdbXAfLG3ujR8g@mail.gmail.com>
In-Reply-To: <CAL1qeaGGSs5fpqrKWA4u4+RXRy9Ko2pN=s9QQdbXAfLG3ujR8g@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 06:29 PM, Andrew Bresticker wrote:
>>         sdhci@0,700b0600 {
>>                 status = "okay";
>>                 bus-width = <8>;
>> +               vqmmc-supply = <&vddio_1v8>;
> 
> It turns out this bit isn't needed as the initialization failures are
> instead due to +3V3_RUN toggling, which Stephen has fixed:
> http://patchwork.ozlabs.org/patch/339386/

Indeed, if I apply patches 1, 2, and 4 from this series, revert the hunk
above, apply my Venice2 regulator patch, and finally apply your AS3722
regulator GPIO patch, then everything works fine for me:-)
