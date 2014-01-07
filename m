Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaAGVl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:41:28 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:45385 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaAGVlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:41:23 -0500
Date: Tue, 7 Jan 2014 16:41:19 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: Re: [PATCHSET driver-core-next] kernfs, sysfs, driver-core:
 implement synchronous self-removal
Message-ID: <20140107214119.GG3231@htj.dyndns.org>
References: <1389117590-25705-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389117590-25705-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 12:59:38PM -0500, Tejun Heo wrote:
> This patchset improves kernfs removal path and implements
> kernfs_remove_self() which is to be called from an on-going kernfs
> operation and removes the self node.  The function can be called
> concurrently and only one will return %true and all others will wait
> until the winner's file operation is complete (not the
> kernfs_remove_self() call itself but the enclosing file operation
> which invoked the function).  This ensures that if there are multiple
> concurrent "echo 1 > asdf/delete", all of them would finish only after
> the whole store_delete() method is complete.

Heh, dang it.  Please ignore this posting.  I thought I could get away
with this but apparently cgroup would need something a bit more
flexible. :(

I'll post an updated version later.

Thanks.

-- 
tejun
