Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaBRPdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:33:22 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:47273 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbaBRPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:30:59 -0500
Date: Tue, 18 Feb 2014 10:30:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Document exceptions to work item
 non-reentrancy guarantee
Message-ID: <20140218153056.GC30043@htj.dyndns.org>
References: <1392493119-9277-1-git-send-email-peter@hurleysoftware.com>
 <1392687834.10088.17.camel@deadeye.wl.decadent.org.uk>
 <5302C58E.1070903@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5302C58E.1070903@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 09:29:34PM -0500, Peter Hurley wrote:
> >It never would have occurred to me that you could safely change the
> >function for a work item that is already scheduled or running.
> >Especially given that PREPARE_WORK() is just a simple assignment (i.e.
> >no serialisation).
> 
> process_one_work() has an established order that safely allows for
> resetting the work function and scheduling the work, and further
> guaranteeing that the new work function will run.
> 
> Further, existing memory barriers ensure that
> 1. The new work function is visible on all cpus before testing if
>    the work is already pending.
> 2. The new work function is stored as the worker's current function
>    before the work is marked as not pending.
> 
> If this wasn't possible, then single-threaded workqueues could
> not be used for multiple functions without flushing work.
> 
> I wonder if the floppy driver is broken too.

Ugh... I'd just rather remove PREPARE_WORK altogether.  It's a pretty
dumb thing to do anyway.  I'll look into it.

Thanks.

-- 
tejun
