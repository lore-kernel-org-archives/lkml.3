Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3JCU6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:58:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab3JCU6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:58:24 -0400
Date: Thu, 3 Oct 2013 13:58:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        aswin@hp.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm,fs: introduce helpers around i_mmap_mutex
Message-Id: <20131003135822.e0b2ca10fe5a460714bb82a3@linux-foundation.org>
In-Reply-To: <1380745066-9925-2-git-send-email-davidlohr@hp.com>
References: <1380745066-9925-1-git-send-email-davidlohr@hp.com>
	<1380745066-9925-2-git-send-email-davidlohr@hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Oct 2013 13:17:45 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> Various parts of the kernel acquire and release this mutex,
> so add i_mmap_lock_write() and immap_unlock_write() helper
> functions that will encapsulate this logic. The next patch
> will make use of these.
> 
> ...
>
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -478,6 +478,16 @@ struct block_device {
>  
>  int mapping_tagged(struct address_space *mapping, int tag);
>  
> +static inline void i_mmap_lock_write(struct address_space *mapping)
> +{
> +	mutex_lock(&mapping->i_mmap_mutex);
> +}

I don't understand the thinking behind the "_write".  There is no
"_read" and all callsites use "_write", so why not call it
i_mmap_lock()?

I *assume* the answer is "so we can later convert some sites to a new
i_mmap_lock_read()".  If so, the changelog should have discussed this. 
If not, still confused.


