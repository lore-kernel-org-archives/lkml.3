Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaAIEgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:36:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaAIEf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:35:58 -0500
Date: Wed, 8 Jan 2014 20:36:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang YanQing <udknight@gmail.com>, jslaby@suse.cz, airlied@redhat.com,
        akpm@linux-foundation.org, kilobyte@angband.pl,
        peter@hurleysoftware.com, rosslagerwall@gmail.com, tiwai@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4]vt: use vc_allocate in con_init
Message-ID: <20140109043621.GC28887@kroah.com>
References: <20140107231310.GA3397@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107231310.GA3397@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 07:13:10AM +0800, Wang YanQing wrote:
> After a5f4f52e82114e85aa1a066bd1a450acc19a464d
> ("vt: use kzalloc() instead of the bootmem allocator"),
> con_init began to use kzalloc to initialize vc_data,
> this patch convert con_init to use vc_allocate.
> 
> The benefit we get:
> 1: reduce code duplication
> 2: vc_allocate is more robust
> 3: use kmalloc instead of kzalloc for vc_screenbuf
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  this patch don't have v2 :) I jump to v3 directly
>  from v1, but I keep the mistake for less confusion.
> 
>  Changes v3-v4:
>  1: use bool/true/false instead of int/1/0
> 
>  Thanks for Jiri Slaby
> 
>  drivers/tty/vt/vt.c       | 28 ++++++++++++++--------------
>  drivers/tty/vt/vt_ioctl.c |  8 ++++----
>  include/linux/vt_kern.h   |  2 +-
>  3 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 15aaa01..c0d6255 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -748,7 +748,8 @@ static void visual_init(struct vc_data *vc, int num, int init)
>  	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
>  }
>  
> -int vc_allocate(unsigned int currcons)	/* return 0 on success */
> +/* return 0 on success */
> +int vc_allocate(unsigned int currcons, bool early)

What does "early" mean?  I understand the goal of making the code
smaller (hint, it's the same size overall with this change), but adding
flags like this just makes things a whole lot harder to debug and
understand later on.

I really don't like this as it adds to the programmer's complexity at
the tradeoff of a chance at smaller code.

sorry,

greg k-h
