Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKGFwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:52:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaKGFwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:52:50 -0500
Date: Thu, 6 Nov 2014 21:51:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        linux-kernel@vger.kernel.org,
        Weng Meiling <wengmeiling.weng@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] sysfs: driver core: Fix glue dir race condition
Message-ID: <20141107055139.GA29210@kroah.com>
References: <1415261798-9671-1-git-send-email-wangyijing@huawei.com>
 <20141106165547.GG25642@htj.dyndns.org>
 <20141106172246.GA20192@kroah.com>
 <545C2408.60703@huawei.com>
 <20141107024654.GC22844@kroah.com>
 <545C3893.3020003@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545C3893.3020003@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:12:19AM +0800, Yijing Wang wrote:
> >> +static DEFINE_MUTEX(gdp_mutex);
> >>
> >>  static struct kobject *get_device_parent(struct device *dev,
> >>  					 struct device *parent)
> >>  {
> >>  	if (dev->class) {
> >> -		static DEFINE_MUTEX(gdp_mutex);
> >>  		struct kobject *kobj = NULL;
> >>  		struct kobject *parent_kobj;
> >>  		struct kobject *k;
> >> @@ -793,7 +793,9 @@ static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
> >>  	    glue_dir->kset != &dev->class->p->glue_dirs)
> >>  		return;
> >>
> >> +	mutex_lock(&gdp_mutex);
> >>  	kobject_put(glue_dir);
> >> +	mutex_unlock(&gdp_mutex);
> >>  }
> >>
> >>  static void cleanup_device_parent(struct device *dev)
> >>
> > 
> > I much prefer this patch over the other one, as it keeps the same
> > behavior as today, and fixes the existing bug.
> > 
> > Have you tested it out to see if it works properly?  If so, can you
> > resend it in a "proper" form so I can apply it?
> 
> Yes, we tested it in our system, I will resend it now, thanks!

Wonderful, thanks for that, and persisting with this.  I'll queue up
that patch tomorrow morning.

greg k-h
