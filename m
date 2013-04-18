Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968188Ab3DRKn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:43:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33709 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968154Ab3DRKn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:43:58 -0400
Date: Thu, 18 Apr 2013 11:43:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>, linus.walleij@stericsson.com,
        arnd@arndb.de, Vinod Koul <vinod.koul@intel.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 03/32] dmaengine: ste_dma40: Use the BIT macro to
	replace ugly '(1 << x)'s
Message-ID: <20130418104338.GM14496@n2100.arm.linux.org.uk>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:11:45AM +0100, Lee Jones wrote:
> The aim is to make the code that little more readable.

Maybe we should also invent the MULT() macro too, because a * b is just
too ugly as well?  Maybe ADD(), SUB() and DIV() macros as well...  Think
of all those extra parens you could use! :)

> @@ -1448,7 +1448,7 @@ static u32 d40_residue(struct d40_chan *d40c)
>  			  >> D40_SREG_ELEM_PHY_ECNT_POS;
>  	}
>  
> -	return num_elt * (1 << d40c->dma_cfg.dst_info.data_width);
> +	return num_elt * BIT(d40c->dma_cfg.dst_info.data_width);

This should be:
	return num_elt << d40c->dma_cfg.dst_info.data_width;
