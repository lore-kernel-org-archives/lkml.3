Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285AbaBDVej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:34:39 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63340 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934584AbaBDVed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:34:33 -0500
Date: Tue, 4 Feb 2014 13:34:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: kosaki.motohiro@gmail.com
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] __set_page_dirty uses spin_lock_irqsave instead of
 spin_lock_irq
In-Reply-To: <1391533776-2425-1-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.DEB.2.02.1402041334110.26019@chino.kir.corp.google.com>
References: <1391533776-2425-1-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> To use spin_{un}lock_irq is dangerous if caller disabled interrupt.
> During aio buffer migration, we have a possibility to see the
> following call stack.
> 
> aio_migratepage  [disable interrupt]
>   migrate_page_copy
>     clear_page_dirty_for_io
>       set_page_dirty
>         __set_page_dirty_buffers
>           __set_page_dirty
>             spin_lock_irq
> 
> This mean, current aio migration is a deadlockable. spin_lock_irqsave
> is a safer alternative and we should use it.
> 
> Reported-by: David Rientjes rientjes@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: stable@vger.kernel.org

Acked-by: David Rientjes <rientjes@google.com>
