Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaA0POB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:14:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59052 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaA0POA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:14:00 -0500
Date: Mon, 27 Jan 2014 16:13:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Q] block / zynq: DMA bouncing
Message-ID: <Pine.LNX.4.64.1401271549280.23931@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:TbOll0+Ny/dWdtcUMXF43KrCYblXuM7Tplb2rYcQ+UC
 GEOYm/mvqDwqoe6xVd5alGeHi0eB7/f4wKTMQ+qzVpB+XKPX41
 Z7M8Tbs/OkqMdpmXf5TMByJ2LElSUqk3hBdndZkmRU2N0Ka9JT
 9nrAuyBXZ0PTIAqkIORWb9mD8VSBJTPQlCF1ajPXbeCiQlj6FS
 suHU1BHq8KGmeRAfK0L7QJwX8JDLy4ivrDPsLxDnL4cIc5LY5p
 QNU7AOYtnSmQ1faHnT3FjNQ6y8NLaCc3zboHdyai0fLsDLwOWJ
 heIqK7tH8PpzOUaC3ARFYS0Pfq5+nv96/SgJBt33rjNeonqzoJ
 i2rfYjrQn8h/AKEDSTJMxZt2BH+fHIevBR+Mq+19W6b8CXphnH
 p5hbldOOdsfaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm working on an MMC driver with a DMA capability. All has been working 
well, until at some point I've got a bus error, when the mmc driver had 
been handed in a buffer at 0x3000 physical RAM address. The reason is, 
that on Zynq arch bus masters cannot access RAM below 0x80000. Therefore 
my question: how shall I configure this in software?

The way I found was to use ARM-specific struct dmabounce_device_info and 
implement its .needs_bounce() method to return true for those addresses. 
Is this the right way or is there a better / more straight-forward one?

To do the above I have to enable CONFIG_DMABOUNCE, which then selects 
CONFIG_ZONE_DMA. Having done just that I suddenly discover, that 0x3000 
buffers aren't used any more, so, I cannot actually verify my 
implementation :) Looking at ZONE_DMA it looks like it is still covering 
the whole RAM range (/proc/zoneinfo shows start_pfn=0 in zone DMA), so, I 
don't see why 0x3000 should be excluded now.

So, is using the .needs_bounce() method the correct way to support DMA on 
this arch or is there a better one?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
