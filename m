Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaH2SbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:31:03 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39480 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaH2SbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:31:01 -0400
X-Originating-IP: 131.252.200.96
Date: Fri, 29 Aug 2014 11:30:51 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>, apw@canonical.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: denali: fix include guard and license block of
 denali.h
Message-ID: <20140829183050.GA1532@thin>
References: <1409310051-25726-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409310051-25726-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 08:00:51PM +0900, Masahiro Yamada wrote:
> It looks like this header file is a concatenation of two headers.
> Anyway, the include guard should be renamed and placed at the correct
> postion and the license block in the middle should be deleted.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Looks sensible, since the header above the first diff hunk is the same
modulo filename.

(Side note: could we get checkpatch to complain about comment headers
containing the name of the file they appear in?  They're always either
redundant or wrong.)

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> 
>  drivers/mtd/nand/denali.h | 27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/mtd/nand/denali.h b/drivers/mtd/nand/denali.h
> index 9668174..145bf88 100644
> --- a/drivers/mtd/nand/denali.h
> +++ b/drivers/mtd/nand/denali.h
> @@ -17,6 +17,9 @@
>   *
>   */
>  
> +#ifndef __DENALI_H__
> +#define __DENALI_H__
> +
>  #include <linux/mtd/nand.h>
>  
>  #define DEVICE_RESET				0x0
> @@ -400,28 +403,6 @@
>  #define ONFI_BLOOM_TIME         1
>  #define MODE5_WORKAROUND        0
>  
> -/* lld_nand.h */
> -/*
> - * NAND Flash Controller Device Driver
> - * Copyright (c) 2009, Intel Corporation and its suppliers.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program; if not, write to the Free Software Foundation, Inc.,
> - * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> - *
> - */
> -
> -#ifndef _LLD_NAND_
> -#define _LLD_NAND_
>  
>  #define MODE_00    0x00000000
>  #define MODE_01    0x04000000
> @@ -499,4 +480,4 @@ struct denali_nand_info {
>  extern int denali_init(struct denali_nand_info *denali);
>  extern void denali_remove(struct denali_nand_info *denali);
>  
> -#endif /*_LLD_NAND_*/
> +#endif /* __DENALI_H__ */
> -- 
> 1.9.1
> 
