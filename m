Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaFQKxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:53:53 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:55611 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbaFQKxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:53:51 -0400
Date: Tue, 17 Jun 2014 12:53:48 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: rientjes@google.com, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] [PATCH v2] drbd: change one-bit bitfield to be an
 unsigned int
Message-ID: <20140617105348.GH28884@soda.linbit>
Mail-Followup-To: Martin Kepplinger <martink@posteo.de>,
	rientjes@google.com, linux-kernel@vger.kernel.org,
	drbd-dev@lists.linbit.com
References: <alpine.DEB.2.02.1406160225510.30205@chino.kir.corp.google.com>
 <1402988047-16364-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402988047-16364-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 08:54:07AM +0200, Martin Kepplinger wrote:
> The one-bit bitfields are assigned true (1) or false (0) and checked
> for them respectively. While it should work either way and -1 is true
> as well it is more clear to see what's going on when using an unsigned int
> because 1 doesn't silently become -1 behind the label true.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> Thanks for looking at it. This is more of a question: Does this make sense
> to you now? I can be mistaken. It just wasn't totally clear to me at first
> sight and even though it should be, why not try to improve it.
> 
> sparse called it 'dubious' before the change.
> 
> (built but untested)

Patch is completely pointless, really,
and I don't get the motivation for it at all.
BUT.

If it makes someone happy,
and since all of our other bitfields in fact are declared "unsigned xyz:N",
for consistency we can make this unsigned as well.
Will probably fold this with some upcoming change in that struct anyways.

    Lars

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
