Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaGLMXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:23:01 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:58114 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaGLMW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:22:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Date: Sat, 12 Jul 2014 14:22:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Will Deacon <will.deacon@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joerg Roedel <joro@8bytes.org>,
        Olav Haugan <ohaugan@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-arm-msm" <linux-arm-msm@vger.kernel.org>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com> <20140712093917.GD18601@arm.com> <CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
In-Reply-To: <CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201407121422.02078.arnd@arndb.de>
X-Provags-ID: V02:K0:q9M97nt1ivjtgoArSfLKv9+ZvP/6pVJaw4wq0NhrgAD
 KX4y0UbtngsjTc3yupDBZGYMehZP31RcsXvZSoFdlKmvDer0yQ
 A/+8NfJ0rg87vxxfNCI8vadl1zGGr8Q3QKhU6OxSVOLpJZUzbP
 8nhVECkKE04lquLz9uJx8hUJtZqmoNcp75UGI8iNK0eiLj1TND
 7aq9tV8+mWzuF7lKYJZzoTRkRGA60OXcPtVXaFmKtuywN0BKc/
 mvoLzHUt2RhNxAsvVd6Rm6VdtFmeu1Jg1uFZfa03ld7p01l+/O
 pjbSqVNbk7jg/nTslzVBZZxzlPArIReyynmz9yRcXt2cbufE8g
 eTVOHM2tX6SjUOWYGnhw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 July 2014, Rob Clark wrote:
> >> Was there actually a good reason for having the device link to the
> >> iommu rather than the other way around?  How much would people hate it
> >> if I just ignore the generic bindings and use something that works for
> >> me instead.  I mean, it isn't exactly like there is going to be .dts
> >> re-use across different SoC's..  and at least with current IOMMU API
> >> some sort of of_get_named_iommu() API doesn't really make sense.
> >
> > The thing is, if you end up ignoring the generic binding then we have two
> > IOMMUs using the same (ARM SMMU) binding and it begs the question as to
> > which is the more generic! I know we're keen to get this merged, but merging
> > something that people won't use and calling it generic doesn't seem ideal
> > either. We do, however, desperately need a generic binding.
> 
> yeah, ignoring the generic binding is not my first choice.  I'd rather
> have something that works well for everyone.  But I wasn't really sure
> if the current proposal was arbitrary, or if there are some
> conflicting requirements between different platforms.

The common case that needs to be simple is attaching one (master) device
to an IOMMU using the shared global context for the purposes of implementing
the dma-mapping API.

The way that Thierry's binding does that is the obvious solution to this,
and it mirrors what we do in practically every other subsystem. I definitely
want the SMMU to change before anybody starts using it in a real system,
which we fortunately do not have yet.

	Arnd
