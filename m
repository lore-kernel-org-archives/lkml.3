Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaJHVkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:40:51 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49125 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaJHVkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:40:49 -0400
Date: Wed, 8 Oct 2014 14:40:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Gerecke <killertofu@gmail.com>
Cc: jkosina@suse.cz, benjamin.tissoires@gmail.com, pinglinux@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: wacom: Prevent potential null dereference after
 disconnect
Message-ID: <20141008214045.GF15198@dtor-ws>
References: <1412704473-6708-1-git-send-email-killertofu@gmail.com>
 <1412792742-4075-1-git-send-email-killertofu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412792742-4075-1-git-send-email-killertofu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 11:25:42AM -0700, Jason Gerecke wrote:
> Repeated connect/disconnect cycles under GNOME can trigger an occasional
> OOPS from within e.g. wacom_led_select_store, presumably due to a timing
> issue where userspace begins setting a value immediately before the
> device disconnects and our shared data is whisked away.
> 
> Signed-off-by: Jason Gerecke <killertofu@gmail.com>
> ---
> Changes in v2:
>  * Added in missing escape character
> 
>  drivers/hid/wacom_sys.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index 8593047..265429b 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -641,6 +641,9 @@ static ssize_t wacom_led_select_store(struct device *dev, int set_id,
>  	unsigned int id;
>  	int err;
>  
> +	if (!wacom)
> +		return -ENODEV;
> +

Strong NAK. If device could disappear before this check it could as well
disappear after your check.

This patch does not solve anything.

>  	err = kstrtouint(buf, 10, &id);
>  	if (err)
>  		return err;

Thanks.

-- 
Dmitry
