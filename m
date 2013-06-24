Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3FXIs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:48:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64542 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115Ab3FXIs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:48:26 -0400
Date: Mon, 24 Jun 2013 09:47:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: arm64: kernel: add '#ifdef CONFIG_COMPAT' for
 aarch32_break_handler()
Message-ID: <20130624084744.GA23779@mudshark.cambridge.arm.com>
References: <51C53C06.7050205@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51C53C06.7050205@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 06:54:14AM +0100, Chen Gang wrote:
> 
> If 'COMPAT' not defined, aarch32_break_handler() cannot pass compiling,
> so need add '#ifdef' for it just like the header file has done.
> 
> The related make:
> 
>   make ARCH=arm64 randconfig
>   make ARCH=arm64 menuconfig
>   make ARCH=arm64 V=1 EXTRA_CFLAGS=-W
> 
> The related error:
> 
>   arch/arm64/kernel/debug-monitors.c:249:5: error: redefinition of ‘aarch32_break_handler’
>   In file included from arch/arm64/kernel/debug-monitors.c:29:0:
>   /root/linux-next/arch/arm64/include/asm/debug-monitors.h:89:12: note: previous definition of ‘aarch32_break_handler’ was here

Actually, can we just kill the static definition in debug-monitors.h
instead? I don't see anything in the full-blown aardch32_break_handler that
won't play nicely if !COMPAT.

Will
