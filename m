Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3CFT5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:57:51 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:53809 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab3CFT5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:57:49 -0500
Date: Wed, 6 Mar 2013 14:58:19 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] dmaengine: add dma_get_slave_sg_caps()
Message-ID: <20130306195819.GN6209@beef>
References: <1360007224-21735-1-git-send-email-mporter@ti.com>
 <1360007224-21735-2-git-send-email-mporter@ti.com>
 <8b3455d3f1aa42818e917d47fd993ea1@DFLE72.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b3455d3f1aa42818e917d47fd993ea1@DFLE72.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 05:08:44PM +0000, Vinod Koul wrote:
> On Mon, Feb 04, 2013 at 02:47:02PM -0500, Matt Porter wrote:
> > Add a dmaengine API to retrieve slave SG transfer capabilities.
> > 
> > The API is optionally implemented by dmaengine drivers and when
> > unimplemented will return a NULL pointer. A client driver using
> > this API provides the required dma channel, address width, and
> > burst size of the transfer. dma_get_slave_sg_caps() returns an
> > SG caps structure with the maximum number and size of SG segments
> > that the given channel can handle.
> Okay this sounds much better :-)
> 
> few points though:
> - you added API for caps, but is actually calculating for given configuration
>   the max allowed range. IMHO that is not caps, perhaps renaming to get_max_sg
>   /some_better_name would be more apt.

I went with get_slave_sg_limits(), seemed pretty descriptive. Just
posted v4 with that change.

> - Still I like the idea of caps, but it should give H/W support capablity. If
>   you want to add that, pls develop on same line...

Ok, seems like a good separate submission.
 
-Matt
