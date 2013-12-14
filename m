Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3LNUzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:55:44 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48210 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3LNUzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:55:43 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:55:36 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] drivers: char: Include appropriate header file in
 frontend.c
Message-ID: <20131214205536.GP17601@leaf>
References: <20131214135148.GA13291@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214135148.GA13291@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:21:48PM +0530, Rashika Kheria wrote:
> This patch includes appropriate header file compat_ioctl.h in
> agp/frontend.c because functions agp_find_mem_by_key(),
> agp_create_segment(), agp_find_private(), agp_free_memory_wrap(),
> agp_allocate_memory_wrap(), agp_find_client_by_pid(),
> agp_create_client(), agp_remove_client(), agpioc_acquire_wrap(),
> agpioc_release_wrap(), agpioc_setup_wrap(), agpioc_protect_wrap() and
> agpioc_deallocate_wrap() have their prototype declaration in
> compat_ioctl.h.
> 
> Thus, it also eliminates the following warnings in agp/frontend.c:
> drivers/char/agp/frontend.c:48:20: warning: no previous prototype for ‘agp_find_mem_by_key’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:164:5: warning: no previous prototype for ‘agp_create_segment’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:216:26: warning: no previous prototype for ‘agp_find_private’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:271:6: warning: no previous prototype for ‘agp_free_memory_wrap’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:277:20: warning: no previous prototype for ‘agp_allocate_memory_wrap’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:489:20: warning: no previous prototype for ‘agp_find_client_by_pid’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:514:20: warning: no previous prototype for ‘agp_create_client’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:527:5: warning: no previous prototype for ‘agp_remove_client’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:750:5: warning: no previous prototype for ‘agpioc_acquire_wrap’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:793:5: warning: no previous prototype for ‘agpioc_release_wrap’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:800:5: warning: no previous prototype for ‘agpioc_setup_wrap’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:880:5: warning: no previous prototype for ‘agpioc_protect_wrap’ [-Wmissing-prototypes]
> drivers/char/agp/frontend.c:914:5: warning: no previous prototype for ‘agpioc_deallocate_wrap’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/char/agp/frontend.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
> index 1b19239..79c8666 100644
> --- a/drivers/char/agp/frontend.c
> +++ b/drivers/char/agp/frontend.c
> @@ -42,6 +42,7 @@
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
>  #include "agp.h"
> +#include "compat_ioctl.h"
>  
>  struct agp_front_data agp_fe;
>  
> -- 
> 1.7.9.5
> 
