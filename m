Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaAMVRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:17:24 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:63587 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaAMVRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:17:20 -0500
Date: Mon, 13 Jan 2014 16:17:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: Re: [PATCHSET v3 driver-core-next] kernfs, sysfs, driver-core:
 implement synchronous self-removal
Message-ID: <20140113211715.GB3480@mtj.dyndns.org>
References: <1389362251-8128-1-git-send-email-tj@kernel.org>
 <20140110150856.GB22533@kroah.com>
 <20140111001953.GA25593@kroah.com>
 <20140111184513.GA3257@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111184513.GA3257@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 01:45:13PM -0500, Tejun Heo wrote:
> Hey, Greg.
> 
> On Fri, Jan 10, 2014 at 04:19:53PM -0800, Greg KH wrote:
> > > It's really late in the -rc cycle for me to take this for 3.14, but I
> > > see patch 1 is a good one to have, so I'll take that now, and queue the
> > > rest up for after 3.14-rc1 is out for 3.15.  Is that ok with you, or do
> > > you have patches that depend on this series for 3.14?
> > 
> > Oh nevermind, these are all good, now applied :)
> 
> I don't have anything depending on the series for the up coming merge
> window so 3.15 merge window would have been fine but 3.14 merge
> windows wokrs too. :)

Greg, I'm sorry but can you please revert the whole series?
get_active() waiting while a node is deactivated has potential to lead
to deadlock and that deactivate/reactivate interface is something
fundamentally flawed and that cgroup will have to work with the
remove_self() like everybody else.  IOW, I think the first posting was
correct.

I think we better defer this to the next window and I'll do the whole
thing - kernfs updates & cgroup conversion - together and then push
out patches so that I don't repeat these mistakes.

Sorry about the mess.  I got tunnel-visioned thinking about cgroup
semantics too much.

Thank you.

-- 
tejun
