Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbbAIKok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:44:40 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34934 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbbAIKoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:44:37 -0500
MIME-Version: 1.0
In-Reply-To: <1418719298-25314-2-git-send-email-tomeu.vizoso@collabora.com>
References: <1418719298-25314-1-git-send-email-tomeu.vizoso@collabora.com> <1418719298-25314-2-git-send-email-tomeu.vizoso@collabora.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 9 Jan 2015 19:44:16 +0900
Message-ID: <CAAVeFu+E-7YooJ=9jVXe48wb_hQi3qFmuo=mB_OzKcSEhRbX+g@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] of: Add binding for NVIDIA Tegra ACTMON node
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 5:41 PM, Tomeu Vizoso
<tomeu.vizoso@collabora.com> wrote:
> This block gathers statistics about various counters and can be configured to
> fire interrupts when thresholds are crossed.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>
> ---
>
> v2:     * Add operating-points property
> ---
>  .../devicetree/bindings/arm/tegra/actmon.txt       | 38 ++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/tegra/actmon.txt
>
> diff --git a/Documentation/devicetree/bindings/arm/tegra/actmon.txt b/Documentation/devicetree/bindings/arm/tegra/actmon.txt
> new file mode 100644
> index 0000000..b4069df
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/tegra/actmon.txt
> @@ -0,0 +1,38 @@
> +Tegra124 Activity Monitor driver

Device Tree describes hardware and is supposed to be
driver-independant, so that "driver" qualifier sounds weird to me -
maybe remove it?

> +
> +Required properties:
> +
> +- compatible: should be "nvidia,tegra124-actmon"
> +- reg: offset and length of the register set for the device
> +- interrupts: standard interrupt property
> +- clocks: Must contain a phandle and clock specifier pair for each entry in clock-names. See ../clock/clock-bindings.txt for details.

Mmm, shouldn't this line be wrapper at character 80? Same throughout this file.

Also from this file the correct patch to clock-bindings.txt is
../../clock/clock-bindings.txt (same for reset.txt later).

Otherwise,

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
