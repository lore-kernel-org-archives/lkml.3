Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaILUs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:48:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaILUsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:48:25 -0400
Date: Fri, 12 Sep 2014 13:48:23 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] toshiba_acpi: Support new keyboard backlight type
Message-ID: <20140912204823.GA23114@vmdeb7>
References: <1410492145-9049-1-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410492145-9049-1-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 09:22:25PM -0600, Azael Avalos wrote:
> Newer Toshiba models now come with a new (and different) keyboard
> backlight implementation with three modes of operation: TIMER,
> ON and OFF, and the LED is controlled internally by the firmware.
> 
> This patch adds support for that type of backlight, changing the
> existing code to accomodate the new implementation.
> 
> The timeout value range is now 1-60 seconds, and the accepted
> modes are now: 1 (FN-Z), 2 (AUTO or TIMER), 8(ON) and 10 (OFF),
> this adds two new entries keyboard_type and available_kbd_modes,

                            ^ update for new naming

> the first shows the keyboard type and the latter shows the
> supported modes depending on the type.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---

Note you can update your v2,v3 changes here after the ---

See Documentation/SubmittingPatches L639,649

> @@ -1293,12 +1420,34 @@ static ssize_t toshiba_kbd_bl_mode_show(struct device *dev,
>  					char *buf)
>  {
>  	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
> -	u32 time;
>  
> -	if (toshiba_kbd_illum_status_get(toshiba, &time) < 0)
> -		return -EIO;
> +	if (toshiba == NULL)
> +		return -ENXIO;

If this testing is necessary for this sysfs callback, it is needed for all of them. Looking at the code more closely, I think this is out of scope for this patch. The entire file assumes a valid toshiba_acpi_dev. If this is a problem, it needs a separate patch to address it. So, let's drop this change, update the commit log to match the new sysfs filenames, and this should be ready to go.


-- 
Darren Hart
Intel Open Source Technology Center
