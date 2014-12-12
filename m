Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbaLLAuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:50:32 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33612 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbaLLAua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+QbAV4emBFOPDJRPOJEYfibmMabz=vWiJzJOB8JYAnvjhzoRA@mail.gmail.com>
References: <CA+QbAV4emBFOPDJRPOJEYfibmMabz=vWiJzJOB8JYAnvjhzoRA@mail.gmail.com>
Date: Thu, 11 Dec 2014 16:50:30 -0800
Message-ID: <CA+QbAV6vD4azDwNNz-W4bg9oAZSKfBY0AqUSidUPnF4eD2Lr6Q@mail.gmail.com>
Subject: Fwd: dma_alloc_coherent allocates same dma address for VF Queue's
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    I am trying to bring up a SR-IOV capable device. It seems that the routine
dma_alloc_coherent returns the DMA address for VF that has been
allocated for PF.

For PF:
  241.005637] XXX: ffff880851576600
[  241.005911] XXX: dmadev ffff881053344098 cqes ffff88084a7ed000
cq_dma_addr 0xfffff000
[  241.005917] XXX: dmadev ffff881053344098 sq_cmds ffff880850062000
sq_dma_addr 0xffffe000

FOR VF:

[  242.208847] XXX: ffff880851574600
[  242.208868] XXX 0000:01:08.0: enabling device (0000 -> 0002)
[  242.208975] XXX: dmadev ffff88085108f098 cqes ffff8808507c6000
cq_dma_addr 0xfffff000
[  242.208979] XXX: dmadev ffff88085108f098 sq_cmds ffff88084a4dd000
sq_dma_addr 0xffffe000

Most likely the device returns wrong information to OS when  I enable VFs.

I have been looking at live kernel memory with the command crash and
trying to understand intel DMA mapping code. If anyone has any input
kindly send a reply.

Thanks,
Kallol
