Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaE1WJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:09:17 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52360 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaE1WJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:09:16 -0400
Date: Wed, 28 May 2014 15:09:12 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH] mtd: bf5xx_nand: use the managed version of kzalloc (Re:
 [PATCH] mtd: Introduce the use of the managed version of kzalloc)
Message-ID: <20140528220912.GE3599@ld-irv-0074>
References: <20140522185848.GA15125@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522185848.GA15125@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 12:28:48AM +0530, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. Also, the now unnecessary label out_err_hw_init is done away
> with and the label out_err_kzalloc is renamed to out_err.
> 
> The following Coccinelle semantic patch was used for making the change:
> 
> @platform@
> identifier p, probefn, removefn;
> @@
> struct platform_driver p = {
>   .probe = probefn,
>   .remove = removefn,
> };
> 
> @prb@
> identifier platform.probefn, pdev;
> expression e, e1, e2;
> @@
> probefn(struct platform_device *pdev, ...) {
>   <+...
> - e = kzalloc(e1, e2)
> + e = devm_kzalloc(&pdev->dev, e1, e2)
>   ...
> ?-kfree(e);
>   ...+>
> }
> 
> @rem depends on prb@
> identifier platform.removefn;
> expression e;
> @@
> removefn(...) {
>   <...
> - kfree(e);
>   ...>
> }
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>

Improved the subject and pushed to l2-mtd.git. Thanks!

Brian
