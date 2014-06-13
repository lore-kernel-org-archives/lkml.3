Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaFMUfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:35:51 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58198 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaFMUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:35:49 -0400
Date: Fri, 13 Jun 2014 13:35:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input - wacom: remove phys field in struct wacom
Message-ID: <20140613203545.GA31651@core.coreip.homeip.net>
References: <1402691344-26196-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402691344-26196-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:29:04PM -0400, Benjamin Tissoires wrote:
> This field is not used, remove it.

We must have lost the assignment, but it should be assigned to phys of
corresponding input device. 

> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/input/tablet/wacom.h     | 1 -
>  drivers/input/tablet/wacom_sys.c | 2 --
>  2 files changed, 3 deletions(-)
> 
> diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
> index 9ebf0ed..70b1e71 100644
> --- a/drivers/input/tablet/wacom.h
> +++ b/drivers/input/tablet/wacom.h
> @@ -114,7 +114,6 @@ struct wacom {
>  	struct mutex lock;
>  	struct work_struct work;
>  	bool open;
> -	char phys[32];
>  	struct wacom_led {
>  		u8 select[2]; /* status led selector (0..3) */
>  		u8 llv;       /* status led brightness no button (1..127) */
> diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> index 2c613cd..94096fd 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -1323,8 +1323,6 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
>  	wacom->intf = intf;
>  	mutex_init(&wacom->lock);
>  	INIT_WORK(&wacom->work, wacom_wireless_work);
> -	usb_make_path(dev, wacom->phys, sizeof(wacom->phys));
> -	strlcat(wacom->phys, "/input0", sizeof(wacom->phys));
>  
>  	endpoint = &intf->cur_altsetting->endpoint[0].desc;
>  
> -- 
> 1.9.0
> 

-- 
Dmitry
