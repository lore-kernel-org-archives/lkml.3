Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaA0We6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:34:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63686 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbaA0We5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:34:57 -0500
Date: Mon, 27 Jan 2014 23:34:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Michal Simek <monstr@monstr.eu>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Q] block / zynq: DMA bouncing
In-Reply-To: <52E69E1E.3020202@monstr.eu>
Message-ID: <Pine.LNX.4.64.1401272329160.30523@axis700.grange>
References: <Pine.LNX.4.64.1401271549280.23931@axis700.grange>
 <20140127170230.GQ15937@n2100.arm.linux.org.uk> <52E69B4E.5010604@monstr.eu>
 <20140127175231.GU15937@n2100.arm.linux.org.uk> <52E69E1E.3020202@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:BSpjZUz18JEtJIgDqOkoyhrH2FvSpJmV82NJqZFu7dW
 iuupA3iodB2KWSJx06Pn8K4+zk7Tqb4QOXMCw/stYvkeOv64qJ
 Y+9BZabQGRqNqXu7hfWE15KNtiGfBPZRi6F6uhMwrusbFyOAQb
 N7rWcDAxu/zLcxYQ0hQ3Fi1FRvrG54m1+IdF3N7UrW5u1YqvUz
 TP4ejW+pRuypttbtnkXhzJFvBy0vjAtQxE1q/iTJIqD3RWC9Bh
 OC/qGdtp2EcE0kiC3j0WLFM2SJDWCePA42ddei/hPMU8A2mrsa
 hN/jTiBPk2qvJofRm5vaZZ+7KJzc349C9eSQuiQFhHk+FWs3Q9
 uFii/ffN7NjWdFoXBArZkKvyd9NJV6qLCyPBc+MWXW0ndY/Ah2
 XPcgmFthS7kEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, Russell,

On Mon, 27 Jan 2014, Michal Simek wrote:

> On 01/27/2014 06:52 PM, Russell King - ARM Linux wrote:
> > On Mon, Jan 27, 2014 at 06:45:50PM +0100, Michal Simek wrote:
> >> Why 0x4000? IRC Linux for ARM is using space for any purpose.
> >> Russell knows this much better than I.
> > 
> > Probably because as the kernel is loaded at 0x8000, it will place the
> > swapper page table at 0x4000, thus covering from 0x4000 upwards.
> 
> Ah yeah swapper.
> 
> > 
> > Thus, the majority of your un-DMA-able memory will be kernel text or
> > swapper page tables.
> 
> Yes, exactly.
> 0x0 - 0x4000 - reserving not to be used by DMA
> 0x4000 - 0x8000 swapper page table
> 0x8000 - 0x80000 kernel text + up

Good, thanks for the explanations and examples, we'll do the same then!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
