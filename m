Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaDPA37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:29:59 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:35254 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaDPA35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <1397526163-20126-5-git-send-email-abrestic@chromium.org>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
	<1397526163-20126-5-git-send-email-abrestic@chromium.org>
Date: Tue, 15 Apr 2014 17:29:56 -0700
X-Google-Sender-Auth: FQ5od8T1hyPN8XBvqvkdquoiCag
Message-ID: <CAL1qeaGGSs5fpqrKWA4u4+RXRy9Ko2pN=s9QQdbXAfLG3ujR8g@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: tegra: fix Venice2 VQMMC regulators
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Bresticker <abrestic@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>         sdhci@0,700b0600 {
>                 status = "okay";
>                 bus-width = <8>;
> +               vqmmc-supply = <&vddio_1v8>;

It turns out this bit isn't needed as the initialization failures are
instead due to +3V3_RUN toggling, which Stephen has fixed:
http://patchwork.ozlabs.org/patch/339386/
