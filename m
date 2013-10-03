Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3JCH1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:27:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40420 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3JCH1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:27:42 -0400
Date: Thu, 3 Oct 2013 08:21:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christian Daudt <csd@broadcom.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, bcm@fixthebug.org
Subject: Re: [PATCH v2] ARM: bcm: Add DEBUG_LL console support
Message-ID: <20131003072153.GE12758@n2100.arm.linux.org.uk>
References: <1379462711-6957-1-git-send-email-csd@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379462711-6957-1-git-send-email-csd@broadcom.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 05:05:11PM -0700, Christian Daudt wrote:
> @@ -980,6 +991,7 @@ config DEBUG_UART_PHYS
>  	default 0xffd82340 if ARCH_IOP13XX
>  	default 0xfff36000 if DEBUG_HIGHBANK_UART
>  	default 0xfffff700 if ARCH_IOP33X
> +	default 0x3e000000 if DEBUG_BCM_KONA_UART

Please take a moment to think about this.

>  	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
>  		DEBUG_UART_8250 || DEBUG_UART_PL01X
>  
> @@ -1035,6 +1047,7 @@ config DEBUG_UART_VIRT
>  	default 0xfef00003 if ARCH_IXP4XX && CPU_BIG_ENDIAN
>  	default 0xfefff700 if ARCH_IOP33X
>  	default 0xff003000 if DEBUG_U300_UART
> +	default 0xfe300000 if DEBUG_BCM_KONA_UART

And this.

In particular, study the list which you are adding to and see whether
you can spot what you're doing wrong.

Thanks.
