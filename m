Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaD1JbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:31:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22560 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaD1Ja7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:30:59 -0400
Date: Mon, 28 Apr 2014 12:30:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        rashika.kheria@gmail.com, linux-kernel@vger.kernel.org,
        tulinizer@gmail.com, michael.banken@mathe.stud.uni-erlangen.de,
        andriy.shevchenko@linux.intel.com, lorenz@badgers.com
Subject: Re: [PATCH] staging: silicom: Remove unused pointer in
 bypass_init_module()
Message-ID: <20140428093029.GT26890@mwanda>
References: <20140426221504.57905f21@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140426221504.57905f21@spike>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 10:15:04PM +0200, Christian Engelmayer wrote:
> Pointer 'pbpctl_dev_c' in function bypass_init_module() is unused.
> Thus remove it.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against v3.15-rc2 as well as branch staging-next
> of tree git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> ---
>  drivers/staging/silicom/bpctl_mod.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
> index 7f3d884..2bf8964 100644
> --- a/drivers/staging/silicom/bpctl_mod.c
> +++ b/drivers/staging/silicom/bpctl_mod.c
> @@ -6372,13 +6372,10 @@ static int __init bypass_init_module(void)
>  	sema_init(&bpctl_sema, 1);
>  	spin_lock_init(&bpvm_lock);
>  	{
> -
> -		struct bpctl_dev *pbpctl_dev_c = NULL;

The code is indented so that it can do that declaration.  Now the you
have removed the declaration, please remove the indent block '{' as
well.

This still falls under the one thing per patch rule because fixing the
indenting and removing the unused declaration are closely related.

regards,
dan carpenter

