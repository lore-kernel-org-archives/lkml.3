Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3AOTB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:01:26 -0500
Received: from a.painless.aa.net.uk ([81.187.30.51]:37468 "EHLO
	a.painless.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab3AOTBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:01:21 -0500
Date: Tue, 15 Jan 2013 19:01:12 +0000
From: Andrew Clayton <andrew@digital-domain.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: qemu-kvm hangs at start up under 3.8.0-rc3-00074-gb719f43
 (works with CONFIG_LOCKDEP)
Message-ID: <20130115190112.6f171c54@omega.digital-domain.net>
In-Reply-To: <alpine.LNX.2.00.1301151939400.14538@pobox.suse.cz>
References: <20130113222958.64840242@omega.digital-domain.net>
	<20130114132736.GA12489@redhat.com>
	<20130114182449.5a163101@omega.digital-domain.net>
	<50F58867.6010507@redhat.com>
	<20130115171756.36566374@zeus.pccl.info>
	<alpine.LNX.2.00.1301151939400.14538@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 19:41:32 +0100 (CET), Jiri Kosina wrote:

[snip]

> Could you please try the patch below and report backt? Thanks.
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] lockdep, rwsem: fix down_write_nest_lock()
> if !CONFIG_DEBUG_LOCK_ALLOC
> 
> Commit 1b963c81b1 ("lockdep, rwsem: provide down_write_nest_lock()") 
> contains a bug in a codepath when CONFIG_DEBUG_LOCK_ALLOC is
> disabled, which causes down_read() to be called instead of
> down_write() by mistake on such configurations. Fix that.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  include/linux/rwsem.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index 413cc11..8da67d6 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -135,7 +135,7 @@ do
> {								\ 
>  #else
>  # define down_read_nested(sem, subclass)
> down_read(sem) -# define down_write_nest_lock(sem, nest_lock)
> down_read(sem) +# define down_write_nest_lock(sem, nest_lock)
> down_write(sem) # define down_write_nested(sem, subclass)
> down_write(sem) #endif
>  

Heh, indeed, that fix's it.

Tested-by: Andrew Clayton <andrew@digital-domain.net>

Cheers,
Andrew
