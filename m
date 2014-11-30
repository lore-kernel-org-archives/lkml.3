Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaK3Iqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 03:46:32 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37042 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaK3Iqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 03:46:31 -0500
Date: Sun, 30 Nov 2014 00:46:27 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v5 0/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141130084627.GD3608@norris-Latitude-E6410>
References: <1417020793-3354-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417020793-3354-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:53:10PM +0100, Boris Brezillon wrote:
> This series provides an implementation for raw accesses taking care of
> hidding the specific layout used by the GPMI controller.
> 
> Best Regards,
> 
> Boris
> 
> Changes since v4:
>  - fixed a few corner cases in gpmi_move_bits (tested it with:
>    https://github.com/bbrezillon/gpmi-move-bits-test/blob/master/gpmi-move-bits-test.c)

Thanks for this.

BTW, I was going to ask if you benchmarked the much simpler
simple_move_bits() version against the more complicated version here,
but I just ran it myself; the simple version performed about 10x slower
when testing on my PC. So I guess that can justify some extra
complexity!

>  - add documentation and comments for the new gpmi functions
> 
> Changes since v3:
>  - add comments to the gpmi_move_bits function
>  - extend raw read/write documentation
>  - move last part of the raw_page_read function into a conditional block
> 
> Changes since v2:
>  - fixed a bug in gpmi_move_bits
>  - add a raw_buffer field to be used when using raw access methods
>    (experienced memory corruptions when directly using page_buffer_virt
>    buffer)
>  - add raw OOB access functions

Other than my comment about move vs. copy, I think this looks good
enough.

Brian
