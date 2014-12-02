Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbaLBTaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:30:17 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:44191 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933841AbaLBT1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:27:00 -0500
Date: Tue, 2 Dec 2014 14:26:55 -0500
From: Tejun Heo <tj@kernel.org>
To: Jeff Layton <jlayton@primarydata.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 00/14] nfsd/sunrpc: add support for a workqueue-based
 nfsd
Message-ID: <20141202192655.GL10918@htj.dyndns.org>
References: <1417544663-13299-1-git-send-email-jlayton@primarydata.com>
 <20141202191814.GK10918@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202191814.GK10918@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 02:18:14PM -0500, Tejun Heo wrote:
...
> unbound.  If strict cpu locality is likely to be beneficial and each
> work item isn't likely to consume huge amount of cpu cycles,
> WQ_CPU_INTENSIVE would fit better; otherwise, WQ_UNBOUND to let the
> scheduler do its thing.

Hmmm... but you're already using WQ_UNBOUND.  Concurrency management
doesn't matter for unbound workqueues.  They really just behave as
shared worker thread pools.  Does turning on WQ_HIGHPRI change
anything?  Workqueue always prefers hot workers which can lead to the
hot ones being penalized for consuming too much CPU time.

Thanks.

-- 
tejun
