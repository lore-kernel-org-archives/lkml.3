Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaBXLKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:10:07 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:34650 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbaBXLKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:10:03 -0500
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 06:10:03 EST
Date: Mon, 24 Feb 2014 12:04:27 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Greg KH <greg@kroah.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
Message-ID: <20140224120427.6394d5dd@linux.lan.towertech.it>
In-Reply-To: <20140222205217.GC16272@mtj.dyndns.org>
References: <5308E3AE.3040405@oracle.com>
	<20140222205217.GC16272@mtj.dyndns.org>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Feb 2014 15:52:17 -0500
Tejun Heo <tj@kernel.org> wrote:

> The problem is rtc_device_unregister().  It grabs rtc->ops_lock and
> then tries to remove the sysfs files.  Some of those sysfs file
> implementations acquire rtc->ops_lock, so it of course can lead to
> deadlocks.  One can't try to delete a sysfs file which acquires a lock
> while holding the same lock.

 Pretty interesting indeed. One option would be to remove
 the sys files before acquiring the lock. But I wonder
 if this could lead to other issues.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

