Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaG1SJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:09:33 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:16655 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaG1SJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:09:30 -0400
Message-ID: <1406570967.2411.51.camel@j-VirtualBox>
Subject: Re: [PATCH -tip/master 7/7] Documentation: Update
 locking/mutex-design.txt disadvantages
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 11:09:27 -0700
In-Reply-To: <1406524724-17946-7-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-7-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 22:18 -0700, Davidlohr Bueso wrote:
> Fortunately Jason was able to reduce some of the overhead we
> had introduced in the original rwsem optimistic spinning -
> an it is now the same size as mutexes. Update the documentation
> accordingly.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  Documentation/locking/mutex-design.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/locking/mutex-design.txt b/Documentation/locking/mutex-design.txt
> index ee231ed..60c482d 100644
> --- a/Documentation/locking/mutex-design.txt
> +++ b/Documentation/locking/mutex-design.txt
> @@ -145,9 +145,9 @@ Disadvantages
>  
>  Unlike its original design and purpose, 'struct mutex' is larger than
>  most locks in the kernel. E.g: on x86-64 it is 40 bytes, almost twice
> -as large as 'struct semaphore' (24 bytes) and 8 bytes shy of the
> -'struct rw_semaphore' variant. Larger structure sizes mean more CPU
> -cache and memory footprint.
> +as large as 'struct semaphore' (24 bytes) and tied, along with rwsems,

My suggestion here is for the above to say 'struct rw_semaphore' instead
of rwsems.

Acked-by: Jason Low <jason.low2@hp.com>

> +for the largest lock in the kernel. Larger structure sizes mean more
> +CPU cache and memory footprint.
>  
>  When to use mutexes
>  -------------------


