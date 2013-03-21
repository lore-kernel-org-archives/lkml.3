Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3CUTRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:17:13 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57778 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3CUTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:17:10 -0400
Date: Thu, 21 Mar 2013 12:17:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] hwrng: exynos - add CONFIG_PM_SLEEP to suspend/resume
 functions
In-Reply-To: <20130321095430.GC26931@gondor.apana.org.au>
Message-ID: <alpine.DEB.2.02.1303211214230.5662@chino.kir.corp.google.com>
References: <003a01ce1ee4$ed8842b0$c898c810$%han@samsung.com> <20130321095430.GC26931@gondor.apana.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Herbert Xu wrote:

> > This patch adds CONFIG_PM_SLEEP to suspend/resume functions to fix
> > the following build warning when CONFIG_PM_SLEEP is not selected.
> > 
> > drivers/char/hw_random/exynos-rng.c:147:12: warning: 'exynos_rng_runtime_suspend' defined but not used [-Wunused-function]
> > drivers/char/hw_random/exynos-rng.c:157:12: warning: 'exynos_rng_runtime_resume' defined but not used [-Wunused-function]
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Patch applied.  Thanks.

Nack, it causes build errors when CONFIG_PM_SLEEP is disabled:

drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_suspend' undeclared here (not in a function)
drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_resume' undeclared here (not in a function)
