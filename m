Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaKGTCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:02:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaKGTCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:02:12 -0500
Date: Fri, 7 Nov 2014 11:02:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drvres: Improve grp->id setting logics in
 devres_open_group()
Message-ID: <20141107190211.GA15864@kroah.com>
References: <1414576787-2074-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414576787-2074-1-git-send-email-Ying.Liu@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 05:59:47PM +0800, Liu Ying wrote:
> Instead of setting grp->id directly with a temporary value and
> then changing it if a certain condition meets, we may check
> the condition first and then decide which value should be set
> to grp->id.  This may save two lines of code and potentially
> reduces a writing operation.
> 
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
>  drivers/base/devres.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index c8a53d1..39e1856 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -544,9 +544,7 @@ void * devres_open_group(struct device *dev, void *id, gfp_t gfp)
>  	INIT_LIST_HEAD(&grp->node[1].entry);
>  	set_node_dbginfo(&grp->node[0], "grp<", 0);
>  	set_node_dbginfo(&grp->node[1], "grp>", 0);
> -	grp->id = grp;
> -	if (id)
> -		grp->id = id;
> +	grp->id = id ? id : grp;

Ick, I _hate_ ? : lines, please don't do that.

greg k-h
