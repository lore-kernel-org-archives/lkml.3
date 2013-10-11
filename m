Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab3JKPy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:54:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab3JKPyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:54:55 -0400
Date: Fri, 11 Oct 2013 08:54:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, toshi.kani@hp.com,
        sjenning@linux.vnet.ibm.com
Subject: Re: [PATCH] Release device_hotplug_lock when store_mem_state returns
 EINVAL
Message-ID: <20131011155454.GA32305@kroah.com>
References: <52579C69.1080304@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52579C69.1080304@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 03:36:25PM +0900, Yasuaki Ishimatsu wrote:
> When inserting a wrong value to /sys/devices/system/memory/memoryX/state file,
> following messages are shown. And device_hotplug_lock is never released.
> 
> ================================================
> [ BUG: lock held when returning to user space! ]
> 3.12.0-rc4-debug+ #3 Tainted: G        W
> ------------------------------------------------
> bash/6442 is leaving the kernel with locks still held!
> 1 lock held by bash/6442:
>  #0:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff8146cbb5>] lock_device_hotplug_sysfs+0x15/0x50
> 
> This issue was introdued by commit fa2be40 (drivers: base: use standard
> device online/offline for state change).
> 
> This patch releases device_hotplug_lcok when store_mem_state returns EINVAL.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> CC: Toshi Kani <toshi.kani@hp.com>
> CC: Seth Jennings <sjenning@linux.vnet.ibm.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Is this needed in 3.12-final, and possibly older kernel releases as well
(3.10, 3.11, etc.)?  Or is it ok for 3.13?

thanks,

greg k-h
