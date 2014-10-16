Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaJPRpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:45:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaJPRpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:45:21 -0400
Date: Thu, 16 Oct 2014 19:42:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the sub_info
	structure
Message-ID: <20141016174209.GB18318@redhat.com>
References: <20141016160042.7f898871@mschwide> <201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Tetsuo Handa wrote:
>
> For both UMH_NO_WAIT and UMH_WAIT_EXEC cases,
>
>   kernel_thread(call_helper, sub_info, CLONE_VFORK | SIGCHLD)
>
> in __call_usermodehelper() waits for do_execve() to succeed or do_exit(),

Well, not really. kernel_thread(CLONE_VFORK) waits for do_exit() or
exec_mmap(), and exec can fail after that.

Oleg.

