Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422665AbaDPPRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:17:54 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:57564 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161469AbaDPPRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:17:53 -0400
Date: Wed, 16 Apr 2014 11:17:49 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v3] Use kernfs_break_active_protection() for device
 online store callbacks
Message-ID: <20140416151749.GE1257@htj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
 <20140410133116.GB25308@htj.dyndns.org>
 <1397189445.3649.14.camel@ThinkPad-T5421>
 <20140411102649.GB26252@mtj.dyndns.org>
 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
 <20140414201315.GD16835@htj.dyndns.org>
 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
 <20140415145017.GK1863@htj.dyndns.org>
 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 16, 2014 at 09:41:40AM +0800, Li Zhong wrote:
> > If so, that is
> > an actually possible deadlock, no?
> 
> Yes, but it seems to me that it is solved in commit 5e33bc41, which uses
> lock_device_hotplug_sysfs() to return a restart syscall error if not
> able to try lock the device_hotplug_lock. That also requires the device
> removing code path to take the device_hotplug_lock. 

But that patch only takes out device_hotplug_lock out of the
dependency graph and does nothing for cpu_add_remove_lock.  It seems
to be that there still is a deadlock condition involving s_active and
cpu_add_remove_lock.  Am I missing something here?

Now that kernfs has a proper mechanism to deal with it, wouldn't it
make more sense to replace 5e33bc41 with prper s_active protection
breaking?

Thanks.

-- 
tejun
