Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaG1RqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:46:14 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:48596 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaG1RqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:46:09 -0400
Date: Mon, 28 Jul 2014 10:46:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ao2@ao2.it>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/4] HID: lenovo: Don't call function in condition,
 show error codes
Message-ID: <20140728174605.GE8982@core.coreip.homeip.net>
References: <1406154648-14000-4-git-send-email-jm@lentin.co.uk>
 <1406385747-2444-1-git-send-email-jm@lentin.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406385747-2444-1-git-send-email-jm@lentin.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 03:42:27PM +0100, Jamie Lentin wrote:
> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
> ---
>  drivers/hid/hid-lenovo.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
> index a56b9e7..f96bf09 100644
> --- a/drivers/hid/hid-lenovo.c
> +++ b/drivers/hid/hid-lenovo.c
> @@ -350,6 +350,7 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
>  	size_t name_sz = strlen(dev_name(dev)) + 16;
>  	char *name_mute, *name_micmute;
>  	int i;
> +	int ret;
>  
>  	/*
>  	 * Only register extra settings against subdevice where input_mapping
> @@ -368,10 +369,9 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
>  	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, 3, 0, 2))
>  		return -ENODEV;
>  
> -	if (sysfs_create_group(&hdev->dev.kobj,
> -				&lenovo_attr_group_tpkbd)) {
> -		hid_warn(hdev, "Could not create sysfs group\n");
> -	}
> +	ret = sysfs_create_group(&hdev->dev.kobj, &lenovo_attr_group_tpkbd);
> +	if (ret)
> +		hid_warn(hdev, "Could not create sysfs group: %d\n", ret);

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry
