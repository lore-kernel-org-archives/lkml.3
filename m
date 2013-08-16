Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3HPQ24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:28:56 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:46480 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab3HPQ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:28:52 -0400
Date: Fri, 16 Aug 2013 12:28:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] print_worker_info: Handle pointer with more care
Message-ID: <20130816162844.GJ2505@htj.dyndns.org>
References: <1376668606-32354-1-git-send-email-richard@nod.at>
 <20130816161229.GI2505@htj.dyndns.org>
 <520E500B.5000408@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E500B.5000408@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 06:15:07PM +0200, Richard Weinberger wrote:
> On UML I hit the case that pwq is NULL.
> Then we oops at &pwq->wq...

Hmmm?  I'm confused.  &pwq->wq is pwq's pointer + wq's offset in pwq.
It doesn't involve dereferencing pwq->wq.  Maybe uml isn't
implementing probe_kernel_thread()?  Now that I think about it, I'm
not sure how it could.

cc'ing uml people.  Hey, guys, workqueue uses proble_kernel_read() to
print out workqueue related information during oops because those
events are completely asynchronous and workqueue states may not be
consistently accessible.  It seems like uml doesn't implement
probe_kernel_read() and tries direct derference of incorrect pointers
leading to its own oops.  Maybe uml should check whether the memory is
mapped from probe_kernel_read()?

Thanks.

-- 
tejun
