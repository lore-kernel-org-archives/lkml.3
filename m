Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaF0LH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:07:27 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53965 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0LHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:07:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
Date: Fri, 27 Jun 2014 13:07:04 +0200
Message-ID: <9283417.yKmnrljUYI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com> <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BYkk8B2JTYNKVGmFUMVrGSF1gCQC/AJX8n6SegCIYTH
 3UGsm0YLbVKew8zf2/Fvdx7RfOXanhSSJDrrD3ZXe3Y2fwykj0
 u+Olcj8EnEK/u+FCJxniC445oEz2KZKux2hOx0UVaMbCCi+Hm0
 hre29CFQaFoXhkqGFQLoXaUOwJclVOmFqN34SOk1kY9MCDtq+x
 B8iB7rs00o1GBwNECGYn8DJrzPWxzOJFl+1Zn8bPn/NeFJ1zSl
 46m7Yyn5JIXralPXmYUxzUBSk33sQcFmBpcwH3zU7dpKOf+50c
 dXhpCERshd6EG3dRGLJBaqXOJd6ZO03O2U4L5KD8iq3holgjrR
 TNpBGcqNhOAt88MohqE0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2014 22:49:44 Thierry Reding wrote:
> +static const struct tegra_mc_client tegra124_mc_clients[] = {
> +       {
> +               .id = 0x01,
> +               .name = "display0a",
> +               .swgroup = TEGRA_SWGROUP_DC,
> +               .smmu = {
> +                       .reg = 0x228,
> +                       .bit = 1,
> +               },
> +               .latency = {
> +                       .reg = 0x2e8,
> +                       .shift = 0,
> +                       .mask = 0xff,
> +                       .def = 0xc2,
> +               },
> +       }, {

This is a rather long table that I assume would need to get duplicated
and modified for each specific SoC. Have you considered to put the information
into DT instead, as auxiliary data in the iommu specifier as provided by
the device?

	Arnd
