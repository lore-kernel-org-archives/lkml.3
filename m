Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161209AbaDPVKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:10:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030183AbaDPVKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:10:05 -0400
Date: Wed, 16 Apr 2014 14:10:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Alessandro Rubini <rubini@gnudd.com>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] FMC: misc_register should not be called while atomic
Message-ID: <20140416211007.GA31451@kroah.com>
References: <5344BF60.5050300@intel.com>
 <1397016815-74608-1-git-send-email-jet.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397016815-74608-1-git-send-email-jet.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 12:13:35PM +0800, Jet Chen wrote:
> Signed-off-by: Jet Chen <jet.chen@intel.com>
> ---
>  drivers/fmc/fmc-chardev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/fmc/fmc-chardev.c b/drivers/fmc/fmc-chardev.c
> index b071039..08c4549 100644
> --- a/drivers/fmc/fmc-chardev.c
> +++ b/drivers/fmc/fmc-chardev.c
> @@ -141,8 +141,8 @@ static int fc_probe(struct fmc_device *fmc)
>  	fc->misc.fops = &fc_fops;
>  	fc->misc.name = kstrdup(dev_name(&fmc->dev), GFP_KERNEL);
>  
> -	spin_lock(&fc_lock);
>  	ret = misc_register(&fc->misc);
> +	spin_lock(&fc_lock);
>  	if (ret < 0) {
>  		kfree(fc->misc.name);
>  		kfree(fc);
> -- 
> 1.9.1

This patch doesn't apply at all, can you please redo it against 3.15-rc1
and resend it so that I can apply it?

thanks,

greg k-h
