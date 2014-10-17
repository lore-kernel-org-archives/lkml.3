Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaJQHFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:05:03 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58770 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaJQHFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:05:00 -0400
Date: Fri, 17 Oct 2014 09:04:52 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the
 sub_infostructure
Message-ID: <20141017090452.7a413f88@mschwide>
In-Reply-To: <20141016215834.GA28864@redhat.com>
References: <20141016160042.7f898871@mschwide>
	<201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp>
	<20141016174209.GB18318@redhat.com>
	<201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp>
	<20141016215834.GA28864@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101707-0013-0000-0000-0000017B9FC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 23:58:34 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 10/17, Tetsuo Handa wrote:
> >
> > Ah, I see. Here is a draft of an updated patch.
> 
> Do you mean this part
> 
> 	>  	sub_info->retval = retval;
> 	> +	/* wait_for_helper() will call umh_complete() if UMH_WAIT_PROC. */
> 	> +	if (wait != UMH_WAIT_PROC)
> 	> +		umh_complete(sub_info);
> 	> +	if (!retval)
> 	> +		return 0;
> 	>  	do_exit(0);
> 	>  }
> 
> ?
> 
> Personally I agree, this looks a bit better to me. But this is cosmetic
> and subjective, I leave this to Martin ;)

I don't mind the different code order. As you seem to prefer the above I
use your version.
 
> I also agree that the changelog could mention exec_mmap. Plus a comment
> about UMH_NO_WAIT && sub_info->complete == NULL. So yes, perhaps v2 makes
> sense if Martin agrees.

Ok, this part is a bit tricky and deserves a comment. I'll create one
and send v2.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

