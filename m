Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3F0IaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:30:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42884 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569Ab3F0IaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:30:22 -0400
Date: Thu, 27 Jun 2013 09:29:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-m32r-ja@ml.linux-m32r.org" <linux-m32r-ja@ml.linux-m32r.org>,
        "linux-m32r@ml.linux-m32r.org" <linux-m32r@ml.linux-m32r.org>
Subject: Re: [PATCH] include/asm-generic/pci.h: include generic
 "pci-dma-compat.h"
Message-ID: <20130627082920.GA14335@darko.cambridge.arm.com>
References: <51CBB98D.3040304@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51CBB98D.3040304@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 05:03:25AM +0100, Chen Gang wrote:
> If an architecture need "generic pci.h", it also need generic "pci-dma-
> compat.h",  so recommend to include it in asm-generic directly.
> 
> And now, for arm64 and m32r, may cause compiling error about it.
> 
> The related error (with allmodconfig):
> 
>   drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_exit’:
>   drivers/media/usb/b2c2/flexcop-usb.c:393:3: error: implicit declaration of function ‘pci_free_consistent’ [-Werror=implicit-function-declaration]
>   drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_init’:
>   drivers/media/usb/b2c2/flexcop-usb.c:410:2: error: implicit declaration of function ‘pci_alloc_consistent’ [-Werror=implicit-function-declaration]
>   drivers/media/usb/b2c2/flexcop-usb.c:410:21: warning: assignment makes pointer from integer without a cast [enabled by default]
>   cc1: some warnings being treated as errors
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

>From the arm64 perspective:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

(but make sure it doesn't break other archs)
