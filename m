Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3LNNUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:20:34 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:58238 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3LNNUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:20:32 -0500
X-Auth-Info: tVbGf/NeLIP3j1wrx2NlH+eNIyc5cvQNUStmvblhNKc=
Date: Sat, 14 Dec 2013 14:20:27 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Alexander Popov <a13xp0p0v88@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        Anatolij Gustschin <agust@denx.de>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dmaengine: remove obsolete comment reference to
 dma_data_direction
Message-ID: <20131214132027.GH26910@book.gsilab.sittig.org>
Mail-Followup-To: Alexander Popov <a13xp0p0v88@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
	Anatolij Gustschin <agust@denx.de>, dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1386742022-2995-1-git-send-email-a13xp0p0v88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386742022-2995-1-git-send-email-a13xp0p0v88@gmail.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 10:07 +0400, Alexander Popov wrote:
> 
> enum dma_transfer_direction is currently used
> in struct dma_slave_config, so update the comment
> 
> Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
> ---
>  include/linux/dmaengine.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 41cf0c3..bd6b882 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -305,9 +305,8 @@ enum dma_slave_buswidth {
>  /**
>   * struct dma_slave_config - dma slave channel runtime config
>   * @direction: whether the data shall go in or out on this slave
> - * channel, right now. DMA_TO_DEVICE and DMA_FROM_DEVICE are
> - * legal values, DMA_BIDIRECTIONAL is not acceptable since we
> - * need to differentiate source and target addresses.
> + * channel, right now. DMA_MEM_TO_DEV and DMA_DEV_TO_MEM are
> + * legal values.
>   * @src_addr: this is the physical address where DMA slave data
>   * should be read (RX), if the source is memory this argument is
>   * ignored.

While I agree with the change to the comment text, I'd put the
description of the patch differently.

You are not removing an obsolete reference, but you are fixing an
erroneous comment.  It's not that dma_data_direction would have
become obsolete, instead it's that dma_slave_config was
documented wrongly.  The previous comment used the wrong data
type for one of its members and thus discussed inappropriate
values out of the type's domain.  Maybe "fix incorrect kerneldoc
for struct dma_slave_config" or something similar could be a
better title.  Especially for those who read the log later and
neither have the patch nor its description at hand.

And you might improve the description's body.  Something like
"the 'direction' member of 'struct dma_slave_config' is of data
type 'enum dma_transfer_direction', so update the 'struct
dma_slave_config' kerneldoc to refer to appropriate values" or
similar.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
