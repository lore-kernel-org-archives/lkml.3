Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaF0JrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:47:05 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12215 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaF0JrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:47:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 27 Jun 2014 02:40:47 -0700
Date: Fri, 27 Jun 2014 12:46:38 +0300
From: Hiroshi DOyu <hdoyu@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Joerg Roedel <joro@8bytes.org>, Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        "Dave Martin" <Dave.Martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>, "Hiroshi Doyu" <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        "Paul Walmsley" <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, "Allen Martin" <AMartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
Message-ID: <20140627124638.7ec150cca163c89727b8953f@nvidia.com>
In-Reply-To: <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-5-git-send-email-thierry.reding@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thierry Reding <thierry.reding@gmail.com> writes:

> From: Thierry Reding <treding@nvidia.com>
>
> The memory controller on NVIDIA Tegra124 exposes various knobs that can
> be used to tune the behaviour of the clients attached to it.
>
> Currently this driver sets up the latency allowance registers to the HW
> defaults. Eventually an API should be exported by this driver (via a
> custom API or a generic subsystem) to allow clients to register latency
> requirements.
>
> This driver also registers an IOMMU (SMMU) that's implemented by the
> memory controller.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/memory/Kconfig                   |    9 +
>  drivers/memory/Makefile                  |    1 +
>  drivers/memory/tegra124-mc.c             | 1945 ++++++++++++++++++++++++++++++
>  include/dt-bindings/memory/tegra124-mc.h |   30 +
>  4 files changed, 1985 insertions(+)
>  create mode 100644 drivers/memory/tegra124-mc.c
>  create mode 100644 include/dt-bindings/memory/tegra124-mc.h

I prefer reusing the existing SMMU and having MC and SMMU separated
since most of SMMU code are not different from functionality POV, and
new MC features are quite independent of SMMU.

If it's really convenient to combine MC and SMMU into one driver, we
could move "drivers/iomm/tegra-smmu.c" here first, and add MC features
on the top of it.
