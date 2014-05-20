Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaETDNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 23:13:50 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:50650 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaETDNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 23:13:49 -0400
Date: Mon, 19 May 2014 23:13:47 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "superlibj8301@gmail.com" <superlibj8301@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] arm: ioremap: Fix static vm area boundary check.
In-Reply-To: <9258c0b00a33484a8d289378047f8cd4@BY2PR03MB505.namprd03.prod.outlook.com>
Message-ID: <alpine.LFD.2.11.1405192306390.17310@knanqh.ubzr>
References: <1400232920-25079-1-git-send-email-Li.Xiubo@freescale.com> <alpine.LFD.2.11.1405161403400.17310@knanqh.ubzr> <9258c0b00a33484a8d289378047f8cd4@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Li.Xiubo@freescale.com wrote:

> > > For each vmalloc area, there is one guard page at the end of it.
> > > so the vm->size = PAGE_ALIGN(offset + request size) + guard page size.
> > 
> > Nope.  There is no guard page for statically created vmalloc areas.
> > 
> 
> Yes, you are right, I'm thinking why the static area has no guard page?

The virtual addresses being used are provided by the static mapping 
descriptions themselves.  Sometimes those mappings are large and 
contiguous, covering multiple peripherals at once with a single TLB, 
etc.  There is simply no room for a guard page, or no guard page at all 
between different areas covered by a single section mapping (1MB worth 
of mapping from a single page table entry).

All this to say that trying to enforce a guard page in those cases is 
likely to throw away all the performance advantage and conplexify 
things.


Nicolas
