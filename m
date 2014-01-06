Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaAFI4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:56:12 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56040 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaAFI4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:56:09 -0500
Message-ID: <52CA6FA6.2090105@suse.cz>
Date: Mon, 06 Jan 2014 09:56:06 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, gregkh@linuxfoundation.org,
        airlied@redhat.com, akpm@linux-foundation.org, kilobyte@angband.pl,
        peter@hurleysoftware.com, rosslagerwall@gmail.com, tiwai@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3]vt: use vc_allocate in con_init
References: <20140102074812.GA4713@udknight>
In-Reply-To: <20140102074812.GA4713@udknight>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 08:48 AM, Wang YanQing wrote:
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
>  Changes v2-v3:
>  1: fix warnings reported by checkpatch.pl 
>  2: clarify changelog
> 
>  drivers/tty/vt/vt.c       | 28 ++++++++++++++--------------
>  drivers/tty/vt/vt_ioctl.c |  8 ++++----
>  include/linux/vt_kern.h   |  2 +-
>  3 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 15aaa01..720a8f9 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -748,7 +748,8 @@ static void visual_init(struct vc_data *vc, int num, int init)
>  	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
>  }
>  
> -int vc_allocate(unsigned int currcons)	/* return 0 on success */
> +/* return 0 on success */
> +int vc_allocate(unsigned int currcons, int early)

Could you use
  bool/true/false
instead of
  int/1/0
please?

-- 
js
suse labs
