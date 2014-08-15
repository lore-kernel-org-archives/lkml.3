Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaHOI4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 04:56:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaHOI4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 04:56:19 -0400
Date: Fri, 15 Aug 2014 10:56:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] HID:hid-logitech: Prevent possibility of infinite loop
 when using /sys interface
In-Reply-To: <1408070581-2460-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1408151056080.5101@pobox.suse.cz>
References: <alpine.LNX.2.00.1408121630000.15220@pobox.suse.cz> <1408070581-2460-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014, Simon Wood wrote:

> If the device data is not accessible for some reason, returning 0 will cause the call to be
> continuously called again as none of the string has been 'consumed'.
> 
> Signed-off-by: Simon Wood <simon@mungewell.org>
> ---
>  drivers/hid/hid-lg4ff.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
> index cc2bd20..7835717 100644
> --- a/drivers/hid/hid-lg4ff.c
> +++ b/drivers/hid/hid-lg4ff.c
> @@ -451,13 +451,13 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
>  	drv_data = hid_get_drvdata(hid);
>  	if (!drv_data) {
>  		hid_err(hid, "Private driver data not found!\n");
> -		return 0;
> +		return -EINVAL;
>  	}
>  
>  	entry = drv_data->device_props;
>  	if (!entry) {
>  		hid_err(hid, "Device properties not found!\n");
> -		return 0;
> +		return -EINVAL;
>  	}
>  

Queued for 3.17, thanks Simon.

-- 
Jiri Kosina
SUSE Labs
