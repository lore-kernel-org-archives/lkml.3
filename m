Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaJVRSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:18:01 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:32835 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaJVRR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:17:58 -0400
MIME-Version: 1.0
In-Reply-To: <1413964424-7599-2-git-send-email-jinkun.hong@rock-chips.com>
References: <1413964424-7599-1-git-send-email-jinkun.hong@rock-chips.com>
	<1413964424-7599-2-git-send-email-jinkun.hong@rock-chips.com>
Date: Wed, 22 Oct 2014 10:17:57 -0700
X-Google-Sender-Auth: Fi3NJBSNVFpMkbpSN1u_KnzJXu0
Message-ID: <CAD=FV=Urn8_F+g0G08MLG3TeJsycpoa5K8+rwGDeG=Pk7dFCqA@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] power-domain: add power domain drivers for
 Rockchip platform
From: Doug Anderson <dianders@chromium.org>
To: "jinkun.hong" <jinkun.hong@rock-chips.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jack Dai <jack.dai@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jinkun,

On Wed, Oct 22, 2014 at 12:53 AM, jinkun.hong
<jinkun.hong@rock-chips.com> wrote:
> +#define to_rockchip_pd(_gpd) container_of(_gpd, struct rockchip_domain, base)
> +
> +static int rockchip_pmu_set_idle_request(struct rockchip_domain *pd,
> +                                        bool idle)
> +{
> +       u32 idle_mask = BIT(pd->idle_shift);
> +       u32 idle_target = idle << (pd->idle_shift);
> +       u32 ack_mask = BIT(pd->ack_shift);
> +       u32 ack_target = idle << (pd->ack_shift);
> +       unsigned int mask = BIT(pd->req_shift);
> +       unsigned int val;
> +       unsigned long flags;

warning: unused variable 'flags'


> +static int rockchip_pmu_set_power_domain(struct rockchip_domain *pd,
> +                                        bool on)
> +{
> +       unsigned long flags;

warning: unused variable 'flags'


I haven't done any review of these patches, but I'll say that I did
pick your patches (along with "PM / clock_ops: Add pm_clk_add_clk()"
from https://patchwork.kernel.org/patch/5105401/) and I was able to
boot up my system.  Also, your series plus a patch to set the GPU
power domain on rk3288 made suspend/resume work better.

-Doug
