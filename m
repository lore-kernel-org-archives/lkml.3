Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3KNFXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 00:23:41 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57231 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3KNFXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 00:23:33 -0500
Date: Thu, 14 Nov 2013 14:23:26 +0900
From: Tejun Heo <tj@kernel.org>
To: zhang.yi20@zte.com.cn
Cc: linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: kmod: avoid propagating PF_NO_SETAFFINITY into userspace child
Message-ID: <20131114052326.GA29031@mtj.dyndns.org>
References: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 14, 2013 at 09:51:47AM +0800, zhang.yi20@zte.com.cn wrote:
> The kernel worker thread has the PF_NO_SETAFFINITY flag, and it is propagated
> into the userspace child. Clearing this flag in usersapce child to enable its
> migrating capability.
> 
> 
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> 
> --- linux3-12/kernel/kmod.c	2013-11-14 09:06:58.991781656 +0000
> +++ linux3-12/kernel/kmod.c	2013-11-14 09:08:47.511781621 +0000
> @@ -217,6 +217,7 @@ static int ____call_usermodehelper(void
>  	 * Avoid propagating that into the userspace child.
>  	 */
>  	set_user_nice(current, 0);
> +	current->flags &= ~PF_NO_SETAFFINITY;

I'm a bit confused.  kernel_thread() doesn't use workqueue or
kthread_bind(), so the thread shouldn't have PF_NO_SETAFFINITY set.
Have you actually observed this happening?

Thanks.

-- 
tejun
