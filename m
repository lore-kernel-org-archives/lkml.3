Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab3GWQCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:02:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3GWQB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:01:59 -0400
Date: Tue, 23 Jul 2013 09:01:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, andi@firstfloor.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz,
        hannes@cmpxchg.org, yinghan@google.com, jasowang@redhat.com,
        kay@vrfy.org
Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
Message-ID: <20130723160158.GC27054@kroah.com>
References: <1374261785-1615-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374261785-1615-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 12:23:05PM -0700, K. Y. Srinivasan wrote:
> The current machinery for hot-adding memory requires having udev
> rules to bring the memory segments online. Export the necessary functionality
> to to bring the memory segment online without involving user space code. 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/base/memory.c  |    5 ++++-
>  include/linux/memory.h |    4 ++++
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 2b7813e..a8204ac 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -328,7 +328,7 @@ static int __memory_block_change_state_uevent(struct memory_block *mem,
>  	return ret;
>  }
>  
> -static int memory_block_change_state(struct memory_block *mem,
> +int memory_block_change_state(struct memory_block *mem,
>  		unsigned long to_state, unsigned long from_state_req,
>  		int online_type)
>  {
> @@ -341,6 +341,8 @@ static int memory_block_change_state(struct memory_block *mem,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL(memory_block_change_state);

EXPORT_SYMBOL_GPL() for all of these please.

And as others have pointed out, I can't export symbols without a user of
those symbols going into the tree at the same time.  So I'll drop this
patch for now and wait for your consumer of these symbols to be
submitted.

thanks,

greg k-h
