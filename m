Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937695Ab3DIKg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:36:57 -0400
Received: from pequod.mess.org ([46.65.169.142]:50209 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934884Ab3DIKg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:36:56 -0400
Date: Tue, 9 Apr 2013 11:36:53 +0100
From: Sean Young <sean@mess.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/5] MEDIA: ttusbir, fix double free
Message-ID: <20130409103653.GA15828@pequod.mess.org>
References: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
 <1365107532-32721-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365107532-32721-2-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 10:32:09PM +0200, Jiri Slaby wrote:
> rc_unregister_device already calls rc_free_device to free the passed
> device. But in one of ttusbir's probe fail paths, we call
> rc_unregister_device _and_ rc_free_device. This is wrong and results
> in a double free.
> 
> Instead, set rc to NULL resulting in rc_free_device being a noop.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Sean Young <sean@mess.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/rc/ttusbir.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
> index cf0d47f..891762d 100644
> --- a/drivers/media/rc/ttusbir.c
> +++ b/drivers/media/rc/ttusbir.c
> @@ -347,6 +347,7 @@ static int ttusbir_probe(struct usb_interface *intf,
>  	return 0;
>  out3:
>  	rc_unregister_device(rc);
> +	rc = NULL;
>  out2:
>  	led_classdev_unregister(&tt->led);
>  out:
> -- 

Acked-by: Sean Young <sean@mess.org>


Sean
