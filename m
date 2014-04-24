Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbaDXOfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:35:23 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:37147 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaDXOfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:35:21 -0400
Date: Thu, 24 Apr 2014 10:35:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
Message-ID: <20140424143517.GC14460@htj.dyndns.org>
References: <1398245539-1618-1-git-send-email-jhovold@gmail.com>
 <20140423141908.GA4781@htj.dyndns.org>
 <1398328155.2805.100.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398328155.2805.100.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 04:29:15PM +0800, Li Zhong wrote:
> On Wed, 2014-04-23 at 10:19 -0400, Tejun Heo wrote:
> > cc'ing Li Zhong who's working on a simliar issue in the following
> > thread and quoting whole body.
> > 
> >   http://thread.gmane.org/gmane.linux.kernel/1680706
> > 
> > Li, this is another variation of the same problem.  Maybe this can be
> > covered by your work too?
> 
> It seems to me that it is about write something to driver attribute, and
> driver unloading. If so, maybe it's not easy to reuse the help functions
> created for device attribute, and device removing.
> 
> But I guess the idea to break the active protection could still be
> applied here:
> 
> Maybe we could try_module_get() here (like the other option suggested by
> Johan?), and break active protection if we could get the module,
> something like below? 

I don't get why try_module_get() matters here.  We can't call into
->store if the object at hand is already destroyed and the underlying
module can't go away if the target device is still alive.
try_module_get() doesn't actually protect the object.  Why does that
matter?  This is self removal, right?  Can you please take a look at
kernfs_remove_self()?

Thanks.

-- 
tejun
