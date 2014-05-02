Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaEBToA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:44:00 -0400
Received: from hygieia.santi-shop.eu ([78.46.175.2]:40030 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaEBTn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:43:59 -0400
Date: Fri, 2 May 2014 21:43:54 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 7/9] drivers/hid/hid-picolcd_fb: avoid world-writable
 sysfs files.
Message-ID: <20140502214354.67061986@neptune.home>
In-Reply-To: <1398137612-9714-8-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
	<1398137612-9714-8-git-send-email-rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 April 2014 Rusty Russell <rusty@rustcorp.com.au> wrote:
> In line with practice for module parameters, we're adding a build-time
> check that sysfs files aren't world-writable.
> 
> Cc: Bruno Prémont <bonbons@linux-vserver.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Fine with me,
  Acked-by: Bruno Prémont <bonbons@linux-vserver.org>

Not sure which tree you plan to push this through, CCing Jiri
as all picoLCD driver went in via HID tree.

> ---
>  drivers/hid/hid-picolcd_fb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
> index c930ab8554ea..7f965e231433 100644
> --- a/drivers/hid/hid-picolcd_fb.c
> +++ b/drivers/hid/hid-picolcd_fb.c
> @@ -501,7 +501,7 @@ static ssize_t picolcd_fb_update_rate_store(struct device *dev,
>  	return count;
>  }
>  
> -static DEVICE_ATTR(fb_update_rate, 0666, picolcd_fb_update_rate_show,
> +static DEVICE_ATTR(fb_update_rate, 0664, picolcd_fb_update_rate_show,
>  		picolcd_fb_update_rate_store);
>  
>  /* initialize Framebuffer device */
