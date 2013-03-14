Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab3CNXn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:43:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35646 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3CNXn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:43:57 -0400
Date: Thu, 14 Mar 2013 23:43:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <will.deacon@arm.com>, nico@linaro.org, matthew.leach@arm.com,
        dave.martin@linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] Latest randconfig build errors for Head.S
Message-ID: <20130314234323.GD4977@n2100.arm.linux.org.uk>
References: <51415428.1070401@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51415428.1070401@asianux.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:38:00PM +0800, Chen Gang wrote:
> Hello Maintainers:
> 
>   are these warnings for head.S OK ?
> 
> 
> make:
>   make V=1 EXTRA_CFLAGS=-W ARCH=arm randconfig
>     (this time, CONFIG_MMU=y)
> 
> warning information:
>   arch/arm/boot/compressed/head.S: Assembler messages:
>   arch/arm/boot/compressed/head.S:565: Warning: (null)
>   arch/arm/boot/compressed/head.S:676: Warning: (null)
>   arch/arm/boot/compressed/head.S:698: Warning: (null)
>   arch/arm/boot/compressed/head.S:722: Warning: (null)
>   arch/arm/boot/compressed/head.S:726: Warning: (null)
>   arch/arm/boot/compressed/head.S:735: Warning: (null)
>   arch/arm/boot/compressed/head.S:978: Warning: (null)
>   arch/arm/boot/compressed/head.S:1017: Warning: (null)
>   arch/arm/boot/compressed/head.S:1018: Warning: (null)
>   arch/arm/boot/compressed/head.S:1048: Warning: (null)
>   arch/arm/boot/compressed/head.S:1055: Warning: (null)
>   arch/arm/boot/compressed/head.S:1063: Warning: (null)
>   arch/arm/boot/compressed/head.S:1074: Warning: (null)
>   arch/arm/boot/compressed/head.S:1088: Warning: (null)
>   arch/arm/boot/compressed/head.S:1120: Warning: (null)
>   arch/arm/boot/compressed/head.S:1122: Warning: (null)
>   arch/arm/boot/compressed/head.S:1123: Warning: (null)
>   arch/arm/boot/compressed/head.S:1130: Warning: (null)
>   arch/arm/boot/compressed/head.S:1162: Warning: (null)

*Sigh*

So our wonderful toolchain has decided to start producing NULL warnings
for every "mcr     p15, 0, rX, c7, c10, 4" instruction?  I'd just ignore
them and hope that the toolchain people fix it.
