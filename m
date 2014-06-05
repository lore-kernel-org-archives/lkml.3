Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaFEMSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:18:14 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35570 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaFEMSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <1401881559-18469-9-git-send-email-mperttunen@nvidia.com>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
	<1401881559-18469-9-git-send-email-mperttunen@nvidia.com>
Date: Thu, 5 Jun 2014 07:18:10 -0500
Message-ID: <CAL_JsqLh7kqnufNaWKdOEFb=m2mViFX4kTGMHOKmHuTAVMr+fA@mail.gmail.com>
Subject: Re: [PATCH 8/9] ata: Add support for the Tegra124 SATA controller
From: Rob Herring <robherring2@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, Tejun Heo <tj@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 6:32 AM, Mikko Perttunen <mperttunen@nvidia.com> wrote:
> This adds support for the integrated AHCI-compliant Serial ATA
> controller present on the NVIDIA Tegra124 system-on-chip.
>
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---

[...]

> +static int tegra_ahci_probe(struct platform_device *pdev)
> +{
> +       const struct of_device_id *match;
> +       struct ahci_host_priv *hpriv;
> +       struct tegra_ahci_priv *tegra;
> +       int ret;
> +
> +       match = of_match_device(tegra_ahci_of_match, &pdev->dev);

This is not needed.

> +       if (!match)
> +               return -EINVAL;
> +
