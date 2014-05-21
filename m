Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaEUJcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:32:42 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49628 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaEUJcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:32:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Wed, 21 May 2014 11:32:23 +0200
Message-ID: <11242680.PQytQQqlPJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140521090244.GB19268@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <4506822.XX7GrvtHhk@wuerfel> <20140521090244.GB19268@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aTZf/Ubwd6rHgiPW3rS6LRtD8WTJQGWXs14VunuDauv
 8KNqs0Gktg+HokwHedQfmS3uGqinByKUGPTLr01bfG0tEJLmge
 VfqU2DsIoHkgS/xQ3kJPtI68sjA76wAVjLlhoMmG8Nog7rKjfn
 GEnRqupkdnsBo3x8I76OHzS2Inx4iLmhDtYRFveRCbfOQ6gBZP
 VEPwQzenTRuOhBLvJy0cNpHQKJXZan8yNfj6pCWNOm+v/uV8Oy
 c4jLKggkJqY4iSeZ4HXjO98SG0w+3NKZqpntWZ3Oj1QPBMoK8H
 V3PpmwmHTIpXJm3QiXTCiQuzA6yp/dRlrFESaeWGcVqwZYoKCs
 vEoLURPU3aD3pS88zNYQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 11:02:45 Thierry Reding wrote:
> On Wed, May 21, 2014 at 10:54:42AM +0200, Arnd Bergmann wrote:
>
> > Right. As long as we always unmap the buffers from the IOMMU after they
> > have stopped being in use, it's very unlikely that even a broken device
> > driver causes a DMA into some bus address that happens to be mapped for
> > another device.
> 
> I think that if buffers remain mapped in the IOMMU when they have been
> deallocated that should be considered a bug.

You could see it as a performance optimization in some cases, e.g. when you
cannot flush individual IOTLBs or doing so is expensive, and you just keep
assigning new addresses until every one has been used, then you do a global
IOTLB flush once. Obviously you have to maintain the IO page tables correctly.

	Arnd
