Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab3EOJkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:40:04 -0400
Received: from mx0.aculab.com ([213.249.233.131]:43138 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758684Ab3EOJkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:40:02 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/3 v3] net/macb: Try to optimize struct macb layout
Date: Wed, 15 May 2013 10:38:44 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B723B@saturn3.aculab.com>
In-Reply-To: <d0bc206ace3baaf681e111ba07c4d0b576839bb4.1368608928.git.nicolas.ferre@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3 v3] net/macb: Try to optimize struct macb layout
Thread-Index: Ac5RTWVRIsVh7wc6ToK3Yu2Mrlel/wAAmqlw
References: <cover.1368608928.git.nicolas.ferre@atmel.com> <d0bc206ace3baaf681e111ba07c4d0b576839bb4.1368608928.git.nicolas.ferre@atmel.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        <hein_tibosch@yahoo.es>, <s.trumtrar@pengutronix.de>,
        <michal.simek@xilinx.com>, <monstr@monstr.eu>,
        "Havard Skinnemoen" <havard@skinnemoen.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Move TX-related fields to the top of the struct so that they end up on
> the same cache line. Move the NAPI struct below that since it is used
> from the interrupt handler. This field is also marked as
> ___cacheline_aligned_in_smp.
> RX-related fields go below those.
> Function pointers and capability mask are immediately after that as
> they are also used in the hot path.
> 
> Move the spinlock before regs since they are usually used together.

Haven't you introduced some holes in the structure?
I suspect that spinloack_t might only be 32bits on
some 64bit systems.
There is certainly one where 'caps' used to be.

...> 
>  struct macb {
> +	spinlock_t		lock;
>  	void __iomem		*regs;
...
> +	struct macb_or_gem_ops	macbgem_ops;
> +
> +	u32			caps;
> 
> -	spinlock_t		lock;
>  	struct platform_device	*pdev;

	David



