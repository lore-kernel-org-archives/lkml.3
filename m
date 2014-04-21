Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaDUWqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 18:46:13 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:43875 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaDUWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 18:46:11 -0400
Date: Mon, 21 Apr 2014 18:46:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
Message-ID: <20140421224606.GE22730@htj.dyndns.org>
References: <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
 <20140414201315.GD16835@htj.dyndns.org>
 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
 <20140415145017.GK1863@htj.dyndns.org>
 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
 <20140416151749.GE1257@htj.dyndns.org>
 <1397717444.4034.15.camel@ThinkPad-T5421>
 <20140417151728.GK15326@htj.dyndns.org>
 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
 <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 21, 2014 at 05:23:50PM +0800, Li Zhong wrote:

Proper /** function comment would be nice.

> +struct kernfs_node *lock_device_hotplug_sysfs(struct device *dev,
> +					       struct device_attribute *attr)

I can see why you did this but let's please not require the user of
this function to see how the thing is working internally.  Let's
return int and keep track of (or look up again) the kernfs_node
internally.

>  {
...
> +	/*
> +	 * We assume device_hotplug_lock must be acquired before removing

Is this assumption true?  If so, can we add lockdep assertions in
places to verify and enforce this?  If not, aren't we just feeling
good when the reality is broken?

...

Function comment please.
> +void unlock_device_hotplug_sysfs(struct device *dev,
> +				 struct kernfs_node *kn)
> +{
> +	unlock_device_hotplug();
> +	kernfs_unbreak_active_protection(kn);
> +	put_device(dev);
> +	kernfs_put(kn);
>  }

Thanks.

-- 
tejun
