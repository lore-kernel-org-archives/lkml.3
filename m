Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaIWFN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:13:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53531 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751209AbaIWFN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:13:56 -0400
Date: Tue, 23 Sep 2014 07:13:52 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: inherit coherent_dma_mask from parent device
Message-ID: <20140923071352.65a6e9ec@bbrezillon>
In-Reply-To: <12718317.Y05azLtl8v@wuerfel>
References: <1411414675-19010-1-git-send-email-boris.brezillon@free-electrons.com>
	<12718317.Y05azLtl8v@wuerfel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, 22 Sep 2014 21:45:40 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 22 September 2014 21:37:55 Boris BREZILLON wrote:
> > dma_mask and dma_parms are already inherited from the parent device but
> > dma_coherent_mask was left uninitialized (set to zero thanks to kzalloc).
> > Set sub-device coherent_dma_mask to its parent value to simplify
> > sub-drivers making use of dma coherent helper functions (those drivers
> > currently have to explicitly set the dma coherent mask using
> > dma_set_coherent_mask function).
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > ---
> > 
> > Hi,
> > 
> > This patch is follow-up of a discussion we had on a KMS driver thread [1].
> > This patch is only copying the parent device coherent_dma_mask to avoid
> > calling specific dma_set_coherent_mask in case the coherent mask is the
> > default one.
> > 
> > I'm a bit surprised this hasn't been done earlier while other dma fields
> > (mask and parms) are already inherited from the parent device, so please
> > tell me if there already was an attempt to do the same, and if so, what
> > was the reson for rejecting it :-).
> > 
> > 
> 
> Seems reasonable to me. It's not clear whether we should always inherit
> the dma_mask, but I see no point in copying just dma_mask but not
> coherent_dma_mask.

I thought about adding a dma_mask field to mfd_cell to override the
default behavior (allocate a new dma_mask and copy the value 
provided by mfd_cell if it's not zero), but I don't see any real use
case where a sub-device does not share the dma capabilities with its
parent.
IMHO, it's safer to keep it as is until someone really need to set a
different dma_mask on a sub-device.

Best Regards,

Boris



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
