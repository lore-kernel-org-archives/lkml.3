Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaEXV4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 17:56:43 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:36519 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaEXV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 17:56:42 -0400
X-Originating-IP: 50.43.32.211
Date: Sat, 24 May 2014 14:56:35 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] lib/debugobjects.c: move __initdata after name
Message-ID: <20140524215634.GC24038@thin>
References: <1400936839-25007-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400936839-25007-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 03:07:19PM +0200, Fabian Frederick wrote:
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

No, don't make this change.  A quick "git grep __initdata" shows that to
the extent it has a consistent placement, it's either right after the
type ("static some_type __initdata varname") or right after the storage
class ("static __initdata some_type varname").  Other similar qualifiers
follow the same pattern.

>  lib/debugobjects.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index b628247..437a6b4 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -791,7 +791,7 @@ struct self_test {
>  	unsigned long	dummy2[3];
>  };
>  
> -static __initdata struct debug_obj_descr descr_type_test;
> +static struct debug_obj_descr descr_type_test __initdata;
>  
>  /*
>   * fixup_init is called when:
> @@ -915,7 +915,7 @@ out:
>  	return res;
>  }
>  
> -static __initdata struct debug_obj_descr descr_type_test = {
> +static struct debug_obj_descr descr_type_test __initdata = {
>  	.name			= "selftest",
>  	.fixup_init		= fixup_init,
>  	.fixup_activate		= fixup_activate,
> @@ -923,7 +923,7 @@ static __initdata struct debug_obj_descr descr_type_test = {
>  	.fixup_free		= fixup_free,
>  };
>  
> -static __initdata struct self_test obj = { .static_init = 0 };
> +static struct self_test obj __initdata = { .static_init = 0 };
>  
>  static void __init debug_objects_selftest(void)
>  {
> -- 
> 1.8.4.5
> 
