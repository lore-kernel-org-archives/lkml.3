Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab3APIE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:04:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7880 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab3APIEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:04:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Jan 2013 00:04:02 -0800
Message-ID: <50F66061.20509@nvidia.com>
Date: Wed, 16 Jan 2013 10:10:09 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 7/8] ARM: tegra: Add board data and 2D clocks
References: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com> <1358249182-17486-8-git-send-email-tbergstrom@nvidia.com> <50F5A3A6.7000801@wwwdotorg.org>
In-Reply-To: <50F5A3A6.7000801@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.01.2013 20:44, Stephen Warren wrote:
> On 01/15/2013 04:26 AM, Terje Bergstrom wrote:
>> Add a driver alias gr2d for Tegra 2D device, and assign a duplicate
>> of 2D clock to that driver alias.
> 
> FYI on this one patch - it won't be applied to the Tegra tree until
> after Prashant's common clock framework changes are applied. As such, it
> will need some rework once those patches are applied, or perhaps won't
> even be relevant any more; see below.

It looks like I need to just drop the patch 7(8 "ARM: tegra: Add board
data and 2D clocks" and change the 2D code to access the clock without a
name. Do you agree?

I'll roll this into the next patch version once I've gathered more comments.

diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index dc7d6c6..a1c5f5c 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -259,7 +259,7 @@ static int gr2d_probe(struct platform_device *dev)
        if (!gr2d)
                return -ENOMEM;

-       gr2d->clk = devm_clk_get(&dev->dev, "gr2d");
+       gr2d->clk = devm_clk_get(&dev->dev, NULL);
        if (IS_ERR(gr2d->clk)) {
                dev_err(&dev->dev, "cannot get clock\n");
                return PTR_ERR(gr2d->clk);

Terje
