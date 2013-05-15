Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3EOJjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:39:03 -0400
Received: from mx0.aculab.com ([213.249.233.131]:43083 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752797Ab3EOJjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:39:01 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/3 v3] net/macb: Try to optimize struct macb layout
Date: Wed, 15 May 2013 10:37:22 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B723A@saturn3.aculab.com>
In-Reply-To: <d0bc206ace3baaf681e111ba07c4d0b576839bb4.1368608928.git.nicolas.ferre@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3 v3] net/macb: Try to optimize struct macb layout
Thread-Index: Ac5RTWVRIsVh7wc6ToK3Yu2Mrlel/wAATEgA
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

> From: Havard Skinnemoen <havard@skinnemoen.net>

> Move the NAPI struct below that since it is used
> from the interrupt handler. This field is also marked as
> ___cacheline_aligned_in_smp.

Is that a good idea if the cache line size is 256 bytes?
Indeed is that ever sane - except for a few special structures
that really need it, and are guaranteed to be allocated
with that much alignment.

	David



