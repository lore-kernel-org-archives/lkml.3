Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672AbaFQTqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:46:48 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38598 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009AbaFQTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:46:47 -0400
Date: Tue, 17 Jun 2014 12:46:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Martin Kepplinger <martink@posteo.de>
cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drbd: change one-bit bitfield to be an unsigned int
In-Reply-To: <1402988047-16364-1-git-send-email-martink@posteo.de>
Message-ID: <alpine.DEB.2.02.1406171243260.18156@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406160225510.30205@chino.kir.corp.google.com> <1402988047-16364-1-git-send-email-martink@posteo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Martin Kepplinger wrote:

> The one-bit bitfields are assigned true (1) or false (0) and checked
> for them respectively. While it should work either way and -1 is true
> as well it is more clear to see what's going on when using an unsigned int
> because 1 doesn't silently become -1 behind the label true.
> 

Nothing is silently becoming anything, I have no idea what you're trying 
to address.  Is there something in drivers/block/drbd that needs this 
change?

> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> Thanks for looking at it. This is more of a question: Does this make sense
> to you now? I can be mistaken. It just wasn't totally clear to me at first
> sight and even though it should be, why not try to improve it.
> 

There's no improvement here, you realize that the sign of one-bit 
bitfields are implementation defined, correct?  On what implementation 
does this patch make a difference?

If you are trying to convert these to unsigned for consistency, then just 
say so in the changelog and don't talk about silent changes or comparisons 
to true and false that obfuscate the fact that this is just a trivial 
cleanup that is based on the author's own preference rather than anything 
else.

> sparse called it 'dubious' before the change.
> 
> (built but untested)
> 
>  drivers/block/drbd/drbd_interval.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
> index f38fcb0..8d670e6 100644
> --- a/drivers/block/drbd/drbd_interval.h
> +++ b/drivers/block/drbd/drbd_interval.h
> @@ -9,8 +9,8 @@ struct drbd_interval {
>  	sector_t sector;	/* start sector of the interval */
>  	unsigned int size;	/* size in bytes */
>  	sector_t end;		/* highest interval end in subtree */
> -	int local:1		/* local or remote request? */;
> -	int waiting:1;
> +	unsigned int local:1;	/* local or remote request? */
> +	unsigned int waiting:1;
>  };
>  
>  static inline void drbd_clear_interval(struct drbd_interval *i)
