Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3CBSRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 13:17:15 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43811 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3CBSRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 13:17:13 -0500
Date: Sat, 2 Mar 2013 10:17:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 30/31] driver/base: implement subsys_virtual_register()
Message-ID: <20130302181727.GB2051@kroah.com>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-31-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362194662-2344-31-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 07:24:21PM -0800, Tejun Heo wrote:
> Kay tells me the most appropriate place to expose workqueues to
> userland would be /sys/devices/virtual/workqueues/WQ_NAME which is
> symlinked to /sys/bus/workqueue/devices/WQ_NAME and that we're lacking
> a way to do that outside of driver core as virtual_device_parent()
> isn't exported and there's no inteface to conveniently create a
> virtual subsystem.

I'm almost afraid to ask what you want to export to userspace for a
workqueue that userspace would care about...

If you create a subsystem, the devices will show up under the virtual
"bus" if you don't give them a parent, so this patch shouldn't be
needed, unless you are abusing the driver model.  What am I missing
here?

thanks,

greg k-h
