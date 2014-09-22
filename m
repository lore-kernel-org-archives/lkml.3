Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaIVO5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:57:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbaIVO5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:57:18 -0400
Date: Mon, 22 Sep 2014 10:57:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resource: Add NULL check in next_resource
Message-ID: <20140922145704.GC4250@redhat.com>
References: <1411314704-27072-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411314704-27072-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 08:51:44AM -0700, Guenter Roeck wrote:
> Commit 8c86e70acead ("resource: provide new functions to walk through
> resources") adds a suble new requirement that iomem_resource.child must
> not be NULL when walk_system_ram_range is called. This can cause a crash
> if it turns out that there are no children. The crash ('Unable to handle
> kernel NULL pointer dereference') is seen when trying to test a crisv32
> image on kernels with this commit applied.
> 
> Fix by adding a NULL check into next_resource().
> 
> Fixes: 8c86e70acead ("resource: provide new functions to walk through resources")

Hi Guenter,

Can you please provide backtrace of the crash.

Thanks
Vivek

> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> The NULL check could be added elsewhere instead. I am open to suggestions.
> 
>  kernel/resource.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 60c5a38..00c57ad 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -61,6 +61,9 @@ static DEFINE_SPINLOCK(bootmem_resource_lock);
>  
>  static struct resource *next_resource(struct resource *p, bool sibling_only)
>  {
> +	if (p == NULL)
> +		return NULL;
> +
>  	/* Caller wants to traverse through siblings only */
>  	if (sibling_only)
>  		return p->sibling;
> -- 
> 1.9.1
