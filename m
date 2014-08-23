Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaHWPU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:20:28 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56178 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaHWPU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:20:26 -0400
X-Originating-IP: 50.43.15.134
Date: Sat, 23 Aug 2014 08:20:15 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Paul Mackerras <paulus@samba.org>, kernel-janitors@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] video: fbdev: aty: use c99 initializers in structures
Message-ID: <20140823152015.GB2074@thin>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
 <1408792831-25615-9-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408792831-25615-9-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 01:20:30PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use c99 initializers for structures.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @decl@
> identifier i1,fld;
> type T;
> field list[n] fs;
> @@
> 
> struct i1 {
>  fs
>  T fld;
>  ...};
> 
> @bad@
> identifier decl.i1,i2;
> expression e;
> initializer list[decl.n] is;
> @@
> 
> struct i1 i2 = { is,
> + .fld = e
> - e
>  ,...};
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

One comment below about formatting.  With that addressed:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> --- a/drivers/video/fbdev/aty/aty128fb.c
> +++ b/drivers/video/fbdev/aty/aty128fb.c
> @@ -324,14 +324,57 @@ struct aty128_meminfo {
>  };
>  
>  /* various memory configurations */
> -static const struct aty128_meminfo sdr_128   =
> -	{ 4, 4, 3, 3, 1, 3, 1, 16, 30, 16, "128-bit SDR SGRAM (1:1)" };
> -static const struct aty128_meminfo sdr_64    =
> -	{ 4, 8, 3, 3, 1, 3, 1, 17, 46, 17, "64-bit SDR SGRAM (1:1)" };
> -static const struct aty128_meminfo sdr_sgram =
> -	{ 4, 4, 1, 2, 1, 2, 1, 16, 24, 16, "64-bit SDR SGRAM (2:1)" };
> -static const struct aty128_meminfo ddr_sgram =
> -	{ 4, 4, 3, 3, 2, 3, 1, 16, 31, 16, "64-bit DDR SGRAM" };
> +static const struct aty128_meminfo sdr_128 = {
> +	.ML = 4,
> +	.MB = 4,
> +	.Trcd = 3,
> +	.Trp = 3,
> +	.Twr = 1,
> +	.CL = 3,
> +	.Tr2w = 1,
> +	.LoopLatency = 16,
> +	.DspOn = 30,
> +	.Rloop = 16,
> +	.name = "128-bit SDR SGRAM (1:1)" };

The closing brace should be in column 0 of the next line.  Also, the
final field initializer should have a comma after it. (Likewise for the
remaining changes in this file.)

- Josh Triplett
