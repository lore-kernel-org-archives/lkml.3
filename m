Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaI1MnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 08:43:23 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:55861 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaI1MnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 08:43:22 -0400
Date: Sun, 28 Sep 2014 08:43:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_balloon: Convert "vballon" kthread into a
 workqueue
Message-ID: <20140928124318.GA3736@mtj.dyndns.org>
References: <1411662041-10986-1-git-send-email-pmladek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411662041-10986-1-git-send-email-pmladek@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 06:20:41PM +0200, Petr Mladek wrote:
...
>     1st create_freezable_workqueue("vballoon_wq");

All create_*workqueue() interfaces are deprecated.  Please don't
create new usages.  They map to alloc_*workqueue() anyway.

>     2nd alloc_workqueue("vballoon_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);

Is WQ_MEM_RECLAIM necessary here?  Does virtio_balloon depended upon
from memory allocation path?

...
> The 2nd way to create the workqueue has about the same results as kthread.
> This is why it is used in the patch.

You're testing WQ_UNBOUND vs. !WQ_UNBOUND and yes for most use cases,
!WQ_UNBOUND will be more efficient.  The right thing to do in most
cases is using alloc_workqueue() w/ as minimum extra flags as
possible.

Thanks!

-- 
tejun
