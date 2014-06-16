Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaFPJ3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:29:03 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:54005 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbaFPJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:29:00 -0400
Date: Mon, 16 Jun 2014 02:28:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Martin Kepplinger <martink@posteo.de>
cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drbd: change one-bit bitfield to be an unsigned int
In-Reply-To: <1402793121-17181-1-git-send-email-martink@posteo.de>
Message-ID: <alpine.DEB.2.02.1406160225510.30205@chino.kir.corp.google.com>
References: <1402787275-12258-1-git-send-email-martink@posteo.de> <1402793121-17181-1-git-send-email-martink@posteo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2014, Martin Kepplinger wrote:

> The one-bit bitfield has no negative values and thus becomes an
> unsigned int.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>

I'm unsure what you're correcting here.  These bitfields are inherently 
signed, "int local:1" and "int waiting:1" are signed.  They can have one 
of two values, 0 or -1.  So I don't know what you're saying in your 
changelog.

This patch would only make sense if something is testing `local' or 
`waiting' to be equal to 1.  Is that what you're fixing?  If so, please 
specify it in the changelog with an example.

> ---
> Sorry for the visually ugly first patch. Take this one, if any.
> 
> thanks,
>                      martin
> 
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
