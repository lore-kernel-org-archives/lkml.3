Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbaDIQd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:33:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33894 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933143AbaDIQd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:33:56 -0400
Date: Wed, 9 Apr 2014 13:33:26 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        haojian.zhuang@gmail.com,
        David Heidelberger <david.heidelberger@ixit.cz>, eric.y.miao@gmail.com
Subject: Re: [PATCH v2] ARM: pxa: Move iotable mapping inside vmalloc region
Message-ID: <20140409163326.GA17544@arch.cereza>
References: <1385683243-6688-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <2638213.3rVdlp7YXW@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2638213.3rVdlp7YXW@avalon>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 09, Laurent Pinchart wrote:
> Hi Ezequiel,
> 
> On Thursday 28 November 2013 21:00:43 Ezequiel Garcia wrote:
> > In order to remove the following ugly message:
> > 
> >   BUG: mapping for 0x00000000 at 0xff000000 out of vmalloc space
> > 
> > the iotable mappings should be re-located inside the vmalloc
> > region. Such move was introduced at commit:
> > 
> > commit 0536bdf33faff4d940ac094c77998cfac368cfff
> > Author: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Date:   Thu Aug 25 00:35:59 2011 -0400
> > 
> >     ARM: move iotable mappings within the vmalloc region
> > 
> > While at it, condition the mapping to PXA25x and PXA27x, which
> > are the only platforms where it's used.
> > 
> > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> > Cc: David Heidelberger <david.heidelberger@ixit.cz>
> > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > ---
> > David,
> > 
> > Is it possible for you to give this a try on your board?
> 
> I'm running into the same issue on a PXA270 system.
> 
> UNCACHED_PHYS_0 is used as an immediate operand to a mov instruction, and thus 
> needs to be encoded as a shifted 8-bit value. One simple solution would be to 
> hardcode it to 0xfd000000 (0xfe000000 is already used for the IMEMC mapping).
> 
> Another solution would be to keep the UNCACHED_PHYS_0 mapping at the end of 
> the vmalloc area (with a fix for the UL problem due to VMALLOC_END) and modify 
> pxa2[57]x_finish_suspend and pm_enter_standby_start to use an ldr instruction 
> instead of a move instruction to load the address.
> 
> As a side note, the IMEMC mapping seems unused, maybe we could thus reclaim it 
> and use 0xfe000000 for UNCACHED_PHYS_0.
> 
> Do you plan to submit a v3 of this patch ?
> 

Not really. I've been a bit busy and couldn't work any longer on this issue,
so feel free to pick the task :-)
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
