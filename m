Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaIAMCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:02:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIAMCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:02:48 -0400
Date: Mon, 1 Sep 2014 14:02:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: mingo@redhat.com, Mark Rustad <mark.d.rustad@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] semaphore: Resolve some shadow warnings
Message-ID: <20140901120244.GI27892@worktop.ger.corp.intel.com>
References: <1409228366-7027-1-git-send-email-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409228366-7027-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 05:19:26AM -0700, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> Resolve some shadow warnings resulting from using the name
> jiffies, which is a well-known global. This is not a problem
> of course, but it could be a trap for someone copying and
> pasting code, and it just makes W=2 a little cleaner.
> 
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Why isn't Mark sending this email?

> ---
>  kernel/locking/semaphore.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
> index 6815171..7782dbc 100644
> --- a/kernel/locking/semaphore.c
> +++ b/kernel/locking/semaphore.c
> @@ -36,7 +36,7 @@
>  static noinline void __down(struct semaphore *sem);
>  static noinline int __down_interruptible(struct semaphore *sem);
>  static noinline int __down_killable(struct semaphore *sem);
> -static noinline int __down_timeout(struct semaphore *sem, long jiffies);
> +static noinline int __down_timeout(struct semaphore *sem, long njiffies);
>  static noinline void __up(struct semaphore *sem);

So what's wrong with calling it "timeout" instead? That's what most
other sites do.
