Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbaDQDJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:09:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbaDQDJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:09:21 -0400
Date: Wed, 16 Apr 2014 20:09:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: jet.chen@intel.com, fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] FMC: misc_register should not be called while atomic
Message-ID: <20140417030925.GA7486@kroah.com>
References: <20140416211007.GA31451@kroah.com>
 <5344BF60.5050300@intel.com>
 <1397016815-74608-1-git-send-email-jet.chen@intel.com>
 <20140416223942.GA2020@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416223942.GA2020@mail.gnudd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:39:42AM +0200, Alessandro Rubini wrote:
> >> --- a/drivers/fmc/fmc-chardev.c
> >> +++ b/drivers/fmc/fmc-chardev.c
> >> @@ -141,8 +141,8 @@ static int fc_probe(struct fmc_device *fmc)
> >>  	fc->misc.fops = &fc_fops;
> >>  	fc->misc.name = kstrdup(dev_name(&fmc->dev), GFP_KERNEL);
> >>  
> >> -	spin_lock(&fc_lock);
> >>  	ret = misc_register(&fc->misc);
> >> +	spin_lock(&fc_lock);
> >>  	if (ret < 0) {
> >>  		kfree(fc->misc.name);
> >>  		kfree(fc);
> >> -- 
> >> 1.9.1
> 
> This is already applied, though in a slightly different way. Commit
> 783c2fb1b. I fixed it in Jul 13 2013 after user reports.
> 
> "git tag --contains 783c2fb1b" reports v3.12-rc1 and later

Then why in the world is it being submitted as a patch to be included?
What is going on here?

confused,

greg k-h
