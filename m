Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028AbaFTPyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:54:07 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49711 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934299AbaFTPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:54:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Fri, 20 Jun 2014 17:53:08 +0200
Message-ID: <39682213.otHMo6zoRf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140618101439.GF32699@arm.com>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com> <20140617233714.GD25525@mithrandir> <20140618101439.GF32699@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BzYNpyh9sa/RMvAU/Ci74B7v1GaV4cgVScFhojWLxBw
 OH4WO9Z+Gedmu75moHdCoaC8xRNveYc9nLQtdPfkRMVX+9siT+
 3LCI1S+iI3w8v9OT6LtnIbjNy+kCGwIEZHRDwmIAEUQeZtVwKr
 uWpgyUYC2X0GnVAaEWz7UGvhVKPgY7ObZhKk1o+IU7Z3lG/V6T
 ItomztZoJOk2C6IdFmSsd/E+Ov/b/EPCsHdDgVxaYuhPDeKoZU
 jF9D36K6LIiwQtuo1Z1sifjuvTgiEAFLsfN1bAUqeIAODReRhI
 Ko75ACe/7WMGvHVJEofDeplIU2L/YXVqBNd5uPs55XX0LKYS0x
 YmZeQdDvuQuq4XGvQ6gk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2014 11:14:39 Will Deacon wrote:
> On Wed, Jun 18, 2014 at 12:37:16AM +0100, Thierry Reding wrote:
>   - Each master has a set of fixed StreamIDs
>   - StreamIDs can be remastered by adding a constant offset (this could also
>     be used to describe RequesterID -> StreamID mapping)
> 
> I'd hope this would be sufficient for most people. Dynamic ID assignment can
> be worked out later (I'm not even sure it belongs in this binding) and any
> mappings other than `add a constant offset' can be treated on a case-by-case
> basis. We don't want to throw the kitchen sink at a language for describing
> arbitrary transformations!
> 
> > We've had similar discussions before (power sequences anyone?) where we
> > tried to come up with a generic way to describe something in device tree
> > that just didn't work out too well. Some things are better done in code,
> > so I think we should at least consider that possibility rather than
> > blindly try and force everything into device tree.
> 
> If we can support 90% of SoCs with a simple DT-based description, we can
> address the corner cases as they arise. I'm not ruling our hardcoding
> topology if we have no choice, but I don't think that's a healthy place to
> start from.

So we could use the "arm,gicv3" comaptible string for all those that
have a relatively simple mapping, and describe that mapping entirely
in DT properties, but use a different compatible string for those
SoCs that have a mapping which we can't easily describe, and then
put that into code?

	Arnd
