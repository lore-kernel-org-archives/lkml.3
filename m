Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314AbaCSRDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:03:36 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47076 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933853AbaCSRDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:03:34 -0400
MIME-Version: 1.0
In-Reply-To: <532997D7.6090608@samsung.com>
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
	<5322FD14.5090602@samsung.com>
	<20140318185605.0380c8dfe6559c06183092e5@samsung.com>
	<532861BE.7020601@samsung.com>
	<20140319100304.5e26fa43ccdfc29178b058e1@samsung.com>
	<532997D7.6090608@samsung.com>
Date: Wed, 19 Mar 2014 10:03:33 -0700
X-Google-Sender-Auth: XiXg-9_9RbsH7OEVO_JydqsqHU0
Message-ID: <CANEJEGuYz28dGT+264CYtG+Tk6htOq=u-t4PWMtsij32X0vJFA@mail.gmail.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API functions
From: Grant Grundler <grundler@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 6:12 AM, Tomasz Figa <t.figa@samsung.com> wrote:
...
> No. Proper Linux drivers must support deferred probing mechanism and there
> should be no assumptions about probing orders. Using other initcall level
> than module_initcall for particular drivers is strongly discouraged.

That's true for "end-point" devices. It's not true for
"infrastructure": Memory, CPU, DMA, Interrupt handling, etc. Those
need to be in place before "normal" drivers get called. This SysMMU
driver provides DMA services for "normal" device drivers. Or do I see
that wrong?

thanks,
grant

ps. I've written IOMMU support for four different IOMMUs on three
operating systems (See drivers/parisc for two linux examples). But I
still feel like I at best have 80% understanding of how this one is
organized/works. Abstract descriptions and convoluted code have been
handicapping me (and lack of time to dig further).
