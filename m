Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaFYKNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:13:09 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59535 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaFYKNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:13:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Olav Haugan <ohaugan@codeaurora.org>, Rob Herring <robherring2@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Wed, 25 Jun 2014 12:12:13 +0200
Message-ID: <6589024.32Qh7fFhXo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140625095735.GI6153@arm.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <130361958.xFghHXmZkz@wuerfel> <20140625095735.GI6153@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XyI7SUS+VTUHa6oAQqisCmZU+3PDtby2Z0pxyyLDvJW
 bwYao5YGzvA3yrTPFNwyMe6cUmAaFQ5ozylWj7OyKEss81tdwM
 Tac3hT8mpTYvVMeaP9jEjgG/reErQbNPiU0FE9Ks3xl7GIgwy1
 CrWJl+gO44Dq9UDJH3tKp5Em6u+iUh7ro3twn75P7fCpVrmGXL
 Okr9EUPKrrWTf8JqssSp59qSy4tRfo3vxKeqKTQ54Q03zAC5sd
 p0cHbS094qpndOWyWY7PyESlyR9q1G7oAPcgACKnUlFV+BCcZi
 5tSZtrrJnVGtO14lr6R+A2X3RubUeFdBOIYHv1ujwHE/C2TEKe
 kX1R/NxmQhk2DUEJE3WU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014 10:57:36 Will Deacon wrote:
> So far, I've been avoiding the hardcoding. However, you could potentially
> build a system with a small number of SMRs (compared to the number of
> StreamIDs) and allocate the StreamIDs in such a way that I think the dynamic
> configuration would be NP complete if we require an optimal SMR allocation.
> 
> However:
> 
>   (1) I don't know of a system where this is the case
>   (2) Not much work has been done on improving the dynamic allocator yet
> 
> which is why I'm still favouring dynamic configuration in the driver.
> 
> The other thing I forgot to mention earlier is that we need to support
> device hotplug in the future, so some level of dynamic configuration
> will always be required.

Ok, got it. So we just hope that we can make dynamic configuration
work all the time, but if it all fails, then we come up with a
hardcoded configuration method.

I guess this could be done similarly to how we handle clocks on
a lot of systems: generally these are dynamic, but you have the
option to provide hints in the clock controller node about how
you expect things to be configured.

For the SMMU that could mean that (if we get into the situation you
describe), we add optional properties to the SMMU node itself
describing how we expect the SMRs to be used.

	Arnd
