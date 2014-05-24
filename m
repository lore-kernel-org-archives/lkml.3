Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaEXWAT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 18:00:19 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:56792 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaEXWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 18:00:17 -0400
X-Originating-IP: 50.43.32.211
Date: Sat, 24 May 2014 15:00:09 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] lib/debugobjects.c: code clean-up
Message-ID: <20140524220009.GD24038@thin>
References: <1400936886-25055-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400936886-25055-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 03:08:06PM +0200, Fabian Frederick wrote:
> Fix some checkpatch warnings.
> 
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Some of these make sense, one of them does not.  Comments below.

Also, please explicitly note the checkpatch warnings you fixed, not just
"Fix some checkpatch warnings.".

> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
[...]
> @@ -415,7 +415,8 @@ int debug_object_activate(void *addr, struct debug_obj_descr *descr)
>  			debug_print_object(obj, "activate");
>  			state = obj->state;
>  			raw_spin_unlock_irqrestore(&db->lock, flags);
> -			ret = debug_object_fixup(descr->fixup_activate, addr, state);
> +			ret = debug_object_fixup(descr->fixup_activate,
> +						 addr, state);

This does not seem like a worthwhile improvement.  Please don't blindly
listen to checkpatch, especially regarding line lengths.

- Josh Triplett
