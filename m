Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaJQHEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:04:43 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:40015 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaJQHC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:02:27 -0400
Date: Fri, 17 Oct 2014 09:02:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the
 sub_infostructure
Message-ID: <20141017090214.24eeef30@mschwide>
In-Reply-To: <201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp>
References: <20141016160042.7f898871@mschwide>
	<201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp>
	<20141016174209.GB18318@redhat.com>
	<201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101707-0029-0000-0000-0000013B82FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2014 06:30:29 +0900
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Regarding UMH_NO_WAIT, the sub_info structure can be freed by
> __call_usermodehelper() before the worker thread returns from
> do_execve(), allowing memory corruption when do_execve() failed
> after exec_mmap() is called.
> 
> Regarding UMH_WAIT_EXEC, the call to umh_complete() allows
> call_usermodehelper_exec() to continue which then frees sub_info.
> 
> To fix this race, we need to make sure that the call to
> call_usermodehelper_freeinfo() in call_usermodehelper_exec() is
> always made after the last store to sub_info->retval.

I like this improved description for the UMH_NO_WAIT and UMH_WAIT_EXEC
cases. I mix it with parts of the original description. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

