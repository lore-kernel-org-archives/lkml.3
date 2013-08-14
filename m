Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab3HNKts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:49:48 -0400
Received: from 8bytes.org ([85.214.48.195]:50324 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab3HNKto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:49:44 -0400
Date: Wed, 14 Aug 2013 12:49:38 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 03/16] iommu/exynos: fix page table maintenance
Message-ID: <20130814104938.GF4491@8bytes.org>
References: <002701ce941a$eecebdb0$cc6c3910$@samsung.com>
 <1516548.d7oQuzQS7g@amdc1227>
 <CANEJEGu1ponghpfvyUsQX16+TZWUV+0KXJ7AehjXpju2N_H+Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGu1ponghpfvyUsQX16+TZWUV+0KXJ7AehjXpju2N_H+Ew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 12:49:42 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520b60c620861088910861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 11:28:44AM -0700, Grant Grundler wrote:
> I can't speak to the previous BUG_ON(). I believe the EADDRESSINUSE
> failures could be either WARN_ON or BUG_ON.   This condition is
> clearly a bug in the generic IOMMU allocator and I think that's why
> KyongHo Cho used BUG_ON.
> 
> Handing out duplicate addresses will generally lead to some sort of
> data corruption or other fault depending on how robust the underlying
> device drivers are written.  So my preference is a BUG_ON to
> immediately flag this condition instead of hoping a device driver will
> correctly handling the dma mapping failure (Some do, most currently
> don't).
> 
> WARN_ON() + return -EADDRESSINUSE would be a good alternative.

Even if it is a real BUG condition, I don't think it is worth to stop
execution at this point. It makes debugging harder and the system less
reliable. I prefer to go with the WARN_ON and an error return value.


	Joerg


