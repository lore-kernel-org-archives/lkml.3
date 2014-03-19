Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaCSSiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:38:01 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36042 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaCSSh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <5329D426.9020706@samsung.com>
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
	<5322FD14.5090602@samsung.com>
	<20140318185605.0380c8dfe6559c06183092e5@samsung.com>
	<532861BE.7020601@samsung.com>
	<20140319100304.5e26fa43ccdfc29178b058e1@samsung.com>
	<532997D7.6090608@samsung.com>
	<CANEJEGuYz28dGT+264CYtG+Tk6htOq=u-t4PWMtsij32X0vJFA@mail.gmail.com>
	<5329D426.9020706@samsung.com>
Date: Wed, 19 Mar 2014 11:37:57 -0700
X-Google-Sender-Auth: CIBWPJhx24lPezaFrwlMa6QEbwU
Message-ID: <CANEJEGtCdMmWXwpoky8USLOBw7jAt1bRw8or-mDK7twxAzhWpA@mail.gmail.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API functions
From: Grant Grundler <grundler@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Grant Grundler <grundler@chromium.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 10:30 AM, Tomasz Figa <t.figa@samsung.com> wrote:
...
> As I said, AFAIK the trend is to get rid of ordering by initcalls and make
> sure that drivers can handle missing dependencies properly, even for
> "services" such as DMA, GPIO, clocks and so on, which after all are provided
> by normal drivers like other.

Ok - I'm not following the general kernel dev trends. initcall()
levels are easy to understand and implement. So I would not be in a
hurry to replace them.

>> ps. I've written IOMMU support for four different IOMMUs on three
>> operating systems (See drivers/parisc for two linux examples). But I
>> still feel like I at best have 80% understanding of how this one is
>> organized/works. Abstract descriptions and convoluted code have been
>> handicapping me (and lack of time to dig further).
>
>
> Well, this is one of my concerns with this driver. It isn't easy to read
> (and so review, maintain, extend and debug found issues).

My postscript comment was more to explain why I'm not confident in my
opinion - not a reason to reject the patch series.  I still consider
the whole series as a step forward. But I'm not the expert here.

Right now, with ~30 patches posted by the exynos iommu (official?)
maintainer, no one else who has a clue will attempt to fix or clean up
those kinds of problems.  i.e. it's useful to enable others to fix
what are essentially unspecified "design pattern" issues.

cheers,
grant
