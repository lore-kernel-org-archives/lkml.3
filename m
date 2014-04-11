Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaDKIOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:14:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaDKIMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com
Subject: Re: [PATCH 01/27] ARM: EXYNOS: Add Exynos3250 SoC ID
Date: Fri, 11 Apr 2014 10:12:30 +0200
Message-ID: <4735652.2Yh9suVdiT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53479545.4050707@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com> <53478C75.60302@samsung.com> <53479545.4050707@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:A6xrOi4kw3+ItNeocfJytkbUXD8SD3EryVCWAdfbs1u
 Krf1cRDDipxKiCZweWygLVvlKoBXX7PbbhWAwiIwOnlbl3cA/C
 4O8fhjovgMji7tqxXrZCItC7MyIyQA571NYnJX/D7hc/lkHyV1
 kfGRbbaf7BuSYpEk0ptr8zClaxrqNubbNTT6F0Bx1vVGwsHyj+
 I+k9KqyDUnQruqpqyKYKyJccJ8letmuao5zuVDNMM9UDO+fKTU
 fx/1RDuPoM+XZ2bmd2vVmoow6iFrS5Gl1GhUOxvrHmeqDYJSCg
 7sUMwjgEehWFQ5Igw5V0CcR6YgNIzRD0wp2QtpFMnTpAtljeyC
 DjZBRUoxkNxWtmD2TlJE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2014 16:09:57 Chanwoo Choi wrote:
> On 04/11/2014 03:32 PM, Chanwoo Choi wrote:
> >>>  
> >>> +#if defined(CONFIG_SOC_EXYNOS3250)
> >>> +# define soc_is_exynos3250()    is_samsung_exynos3250()
> >>> +#else
> >>> +# define soc_is_exynos3250()    0
> >>> +#endif
> >>
> >> In general, I think we have too much code littered with soc_is_<foo>() going
> >> on, so please try to avoid adding more for this SoC. Especially in cases where
> >> you just want to bail out of certain features where we might already have
> >> function pointers to control if a function is called or not, such as the
> >> firmware interfaces.
> >>
> > 
> > Do you prefer dt helper function such as following function instead of new soc_is_xx() ?
> > - of_machine_is_compatible("samsung,exynos3250")
> > 
> 
> I think of_machine_is_compatible() is not proper alternative method.
> of_machine_is_compatible can be only used if CONFIG_OF is enabled.
> 

CONFIG_OF is enabled by definition, that wouldn't be a problem. However,
of_machine_is_compatible() doesn't solve the problem that Olof mentioned,
you still make runtime-decisions based on the SoC ID, which you should not.

Instead, the code should be restructured so it doesn't have to know which
SoC is being used. If some machines work differently from others, that should
be local knowledge within the device driver, and it can use for instance
a DT property of the device node that describes the register set the driver
is using.

	Arnd
