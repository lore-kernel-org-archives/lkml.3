Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaGHPq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:46:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55292 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGHPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:46:23 -0400
X-AuditID: cbfee61a-f79e46d00000134f-13-53bc124db3e2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Subject: Re: [PATCH 6/6] ARM: EXYNOS: Register cpuidle device only on
 Exynos4210 and 5250
Date: Tue, 08 Jul 2014 17:45:55 +0200
Message-id: <156099171.AcKbd1QIut@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <038b01cf9ab7$0de5a440$29b0ecc0$@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
 <1403618235-19353-7-git-send-email-t.figa@samsung.com>
 <038b01cf9ab7$0de5a440$29b0ecc0$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQV1foT3BBi8bzC16F1xls9j0+Bqr
	xeVdc9gsZpzfx2Sx9shddov1M16zWKza9YfRgd1j56y77B6bl9R79G1ZxejxeZNcAEsUl01K
	ak5mWWqRvl0CV8aF4w2MBfe5KtqfPWVvYDzP0cXIySEhYCJx40s7O4QtJnHh3nq2LkYuDiGB
	6YwS5y9dYQVJCAm0MEnMnmAOYrMJWElMbF/FCGKLCKhJ9CzeygjSwCzwklHiy79fYAlhgWiJ
	E6tngtksAqoS/T8ng9m8AtoSc/qegA0VFfCU2LF9JRuIzQk09PLyfYwQm1czSrQeWMgC0SAo
	8WPyPTCbWUBeYt/+qawQtpbE+p3HmSYwCsxCUjYLSdksJGULGJlXMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYgQH9zOpHYwrGywOMQpwMCrx8Crw7AkWYk0sK67MPcQowcGsJML75dTuYCHe
	lMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2Mfs2ux435H7Uf
	fNDmobz5tuzM/Nvpn6fx8U4y2T59usrdjOa0rpOLUpu3VkZ9NJ3/K/FM1jcfIdk/s/uzU9+x
	Oqa/iXn0hlN+Z7XKJdPwev1L2TvWxUwPP9C+gk//ioL2j/51H5fJc8vsnS99kKWpm/FQh3tL
	+Q2/u1dEbi0P/Jxmw2O5pJ9fiaU4I9FQi7moOBEA4ySnBWoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, July 08, 2014 11:15:21 PM Kukjin Kim wrote:
> Tomasz Figa wrote:
> > 
> > Currently, the Exynos cpuidle driver works correctly only on Exynos4210
> > and 5250. Trying to use it with just one CPU online on any other Exynos
> > SoC will lead to system failure, due to unsupported AFTR mode on other
> > SoCs. This patch fixes the problem by registering the driver only on
> > supported SoCs and letting others simply use default WFI mode until
> > support for them is added.
> > 
> Hmm...I thought other SoCs have no problem on cpuidle except exynos5420 and
> exynos5440....something like this would be helpful to avoid system failure.
> But unfortunately this conflicts with Pankaj's cleanup cpufreq_init() and
> cpuidle_init() patch you've reviewed and I've applied in my local...
> 
> I'm going to check which exynos is ok on cpuidle and then sort them out.

Tomasz's patch is correct - currently only Exynos4210 and Exynos5250 work
fine with AFTR mode and upstream kernel (AFTR gets triggered by offlining
CPUs other than CPU0).

[ Exynos4x12 and Exynos3250 need secure firmware support (patches for this
  need to be reworked on top of recent PM/firmware/cpuidle changes).

  Exynos5410 should use big_little cpuidle driver. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

