Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbaGWXhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:37:07 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65376 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbaGWXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:37:05 -0400
Date: Wed, 23 Jul 2014 16:37:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ao2@ao2.it>,
        Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] HID: lenovo: Style fixes
Message-ID: <20140723233700.GA37304@core.coreip.homeip.net>
References: <1406154648-14000-1-git-send-email-jm@lentin.co.uk>
 <1406154648-14000-4-git-send-email-jm@lentin.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406154648-14000-4-git-send-email-jm@lentin.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

On Wed, Jul 23, 2014 at 11:30:47PM +0100, Jamie Lentin wrote:
> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
> ---
>  drivers/hid/hid-lenovo.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
> index a56b9e7..6d55939 100644
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
> +	ret = sysfs_create_group(&hdev->dev.kobj, &lenovo_attr_group_tpkbd);
> +	if (ret)
>  		hid_warn(hdev, "Could not create sysfs group\n");
> -	}
>  
>  	data_pointer = devm_kzalloc(&hdev->dev,
>  				    sizeof(struct lenovo_drvdata_tpkbd),


This change does not make sense unless you show the error code in the
warning.

Thanks.

-- 
Dmitry
