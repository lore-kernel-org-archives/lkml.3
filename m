Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996Ab3LIQPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:15:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29125 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab3LIQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:15:35 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-3c-52a5eca5a12b
From: Tomasz Figa <t.figa@samsung.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: kgene.kim@samsung.com, Heiko Stuebner <heiko@sntech.de>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Doug Andersen <dianders@chromium.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: EXYNOS: pmu: Constify data tables
Date: Mon, 09 Dec 2013 17:15:22 +0100
Message-id: <30145891.cE1204QWiC@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <CAGS+omDq95paoHsf5-i2gbRoSGvqn36zNO93KHGi2FGhfGMsrw@mail.gmail.com>
References: <1384971686-7208-1-git-send-email-djkurtz@chromium.org>
 <1922780.plAOmhqzpW@amdc1227>
 <CAGS+omDq95paoHsf5-i2gbRoSGvqn36zNO93KHGi2FGhfGMsrw@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xa7pL3ywNMvj+Xtri8ZrFTBYNV0Ms
	Jq07wGRxdtlBNovGGfNZLf4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi9uXeR24PVqae9g8
	ZjdcZPH4u+oFs8fmJfUefVtWMXpsvzaP2ePzJrkA9igum5TUnMyy1CJ9uwSujKYDpgUNfBUH
	XtxhbmDczdXFyMkhIWAicXj/Y2YIW0ziwr31bCC2kMBSRombTwK7GLmA7C4miZ8rXrGCJNgE
	1CQ+NzwCKuLgEBFQl/h1wwmkhlngC5PE/SuzWEBqhAXsJdZN3swOYrMIqEpMnnENbCivgJZE
	1+3lYDX8QL3vtj1lArFFBdwkXuzbAlbPKRAs0bXxBBPE4lWMEr3zt0E1C0r8mHwPrJlZQF5i
	3/6prBC2lsT6nceZJjAKzkJSNgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525i
	hMTM1x2MS49ZHWIU4GBU4uENYF4aJMSaWFZcmXuIUYKDWUmEt+E1UIg3JbGyKrUoP76oNCe1
	+BAjEwenVAPjgVMHLJ/+7jlYpT533ZxbVywNbi5g3+Ax7dv1ubezr9b7Kd7WqVo7UdJ7705z
	xdcGWUUZwovOHxDs1w9Qk5xa+kDdJYjHv8X8qdmvXtdnNi3WvLfuPFL+7/x52oyS3Z+vNLHV
	zOfyrrM/+4J1Z8POWaLaT1Tmiqv9tbQK2nHTbgv3OZfdWg90lViKMxINtZiLihMB8bumwncC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 of December 2013 00:11:40 Daniel Kurtz wrote:
> Hi Tomasz,
> 
> Thank you for the reviews.
> 
> On Dec 9, 2013 5:15 AM, "Tomasz Figa" <t.figa@samsung.com> wrote:
> >
> > Hi Daniel,
> >
> > On Thursday 21 of November 2013 02:21:24 Daniel Kurtz wrote:
> > > These tables are all immutable, make them const to save 4416 bytes of RAM.
> > >
> > > size arch/arm/mach-exynos/pmu.o
> > >    text          data     bss
> > >     848          4420       4         // before
> > >    5264             4       4         // after
> >
> > I'm not sure where the mentioned saving of RAM is. Moving data between
> > sections is not supposed to make it use less memory, I believe.
> 
> You are correct.  This was my misunderstanding from doing too much
> work with microcontrollers, where .text sections are accessed in place
> from FLASH for code and const data, but .data memory is copied from a
> FLASH section to a second RAM section at init for access at runtime.
> Most modern Linux systems copy/decompress their code and data sections
> from external storage to RAM anyway, so there is no actual memory
> savings (except potentially the compiler may be able to optimize a bit
> more with the const hint).
> 
> >
> > Anyway, it's a good practice to mark constant data as const, to disallow
> > changing them at runtime by mistake, so the patch is fine. Except some
> > issues I commented on inline.
> 
> Were there supposed to be inline comments?  I don't see any.

Oops, sorry for this, forgot to remove the last sentence. I initially had
one question about the constant pointers below, but I read through the
full code again and answered it myself.

The patch is fine.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

