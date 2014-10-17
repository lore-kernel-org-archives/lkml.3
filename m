Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaJQHyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:54:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:57384 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbaJQHyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:54:10 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 3/3] rheap: move rheap.c from arch/powerpc/lib/ to lib/
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1411613237-2271-2-git-send-email-B45475@freescale.com>
Date: Fri, 17 Oct 2014 09:53:55 +0200
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        B07421@freescale.com, R63061@freescale.com,
        pantelis.antoniou@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <57D1E2E0-077A-4CBE-8534-5B9EE5C81BAE@kernel.crashing.org>
References: <1411613237-2271-1-git-send-email-B45475@freescale.com> <1411613237-2271-2-git-send-email-B45475@freescale.com>
To: Zhao Qiang <B45475@freescale.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 25, 2014, at 4:47 AM, Zhao Qiang <B45475@freescale.com> wrote:

> qe need to use the rheap, so move it to public directory.
> 
> Signed-off-by: Zhao Qiang <B45475@freescale.com>
> ---
> arch/powerpc/Kconfig                                    | 3 ---
> arch/powerpc/include/asm/fsl_85xx_cache_sram.h          | 2 +-
> arch/powerpc/lib/Makefile                               | 2 --
> arch/powerpc/platforms/44x/Kconfig                      | 2 +-
> arch/powerpc/platforms/85xx/Kconfig                     | 2 +-
> arch/powerpc/platforms/Kconfig                          | 2 +-
> arch/powerpc/platforms/Kconfig.cputype                  | 2 +-
> arch/powerpc/sysdev/cpm1.c                              | 2 +-
> arch/powerpc/sysdev/cpm2.c                              | 2 +-
> arch/powerpc/sysdev/cpm_common.c                        | 2 +-
> arch/powerpc/sysdev/ppc4xx_ocm.c                        | 2 +-
> drivers/dma/bestcomm/Kconfig                            | 2 +-
> drivers/soc/qe/Kconfig                                  | 2 +-
> drivers/soc/qe/qe.c                                     | 2 +-
> drivers/soc/qe/qe_common.c                              | 2 +-
> drivers/video/Kconfig                                   | 2 +-
> include/linux/fsl/bestcomm/sram.h                       | 2 +-
> {arch/powerpc/include/asm => include/linux/fsl}/rheap.h | 0
> lib/Kconfig                                             | 3 +++
> lib/Makefile                                            | 2 ++
> {arch/powerpc/lib => lib}/rheap.c                       | 2 +-
> 21 files changed, 21 insertions(+), 21 deletions(-)
> rename {arch/powerpc/include/asm => include/linux/fsl}/rheap.h (100%)
> rename {arch/powerpc/lib => lib}/rheap.c (99%)

Have you guys looked at moving to lib/genalloc.c.  If we are going to keep rheap around the include should be just in include/linux/rheap.h not include/linux/fsl/rheap.h

However, I think genalloc should be used and kill off rheap usage.

- k