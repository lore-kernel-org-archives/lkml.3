Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaFUEHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 00:07:16 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47593 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaFUEHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 00:07:14 -0400
MIME-Version: 1.0
In-Reply-To: <1403285183-15926-1-git-send-email-nm@ti.com>
References: <1403285183-15926-1-git-send-email-nm@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 21 Jun 2014 13:06:53 +0900
Message-ID: <CAAVeFuKhgVEtHMwacr=VoSChU5R2B3aVDhp7R7wRFCkwS=EKSw@mail.gmail.com>
Subject: Re: [PATCH] regulator: palmas: Fix SMPS enable/disable/is_enabled
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "acourbot@nvidia.com" <acourbot@nvidia.com>, j-keerthy@ti.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 2:26 AM, Nishanth Menon <nm@ti.com> wrote:
> We use regmap regulator ops to enable/disable and check if regulator
> is enabled for various SMPS. However, these depend on valid
> enable_reg, enable_mask and enable_value in regulator descriptor.
>
> Currently we do not populate these for SMPS other than SMPS10, this
> results in spurious results as regmap assumes that the values are
> valid and ends up reading register 0x0 RTC:SECONDS_REG on Palmas
> variants that do have RTC! To fix this, we update proper parameters
> for the descriptor fields.
>
> Further, we want to ensure the behavior consistent with logic
> prior to commit dbabd624d4eec50b6, where, once you do a set_mode,
> enable/disable ensure the logic remains consistent and configures
> Palmas to the configuration that we set with set_mode (since the
> configuration register is common). To do this, we can rely on the
> regulator core's regulator_register behavior where the regulator
> descriptor pointer provided by the regulator driver is stored. (no
> reallocation and copy is done). This lets us update the enable_value
> post registration, to remain consistent with the mode we configure as
> part of set_mode.

Tested-by: Alexandre Courbot <acourbot@nvidia.com>

Thanks!
