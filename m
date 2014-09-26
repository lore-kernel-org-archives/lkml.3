Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaIZLZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:25:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbaIZLZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:25:49 -0400
Date: Fri, 26 Sep 2014 13:25:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Johan Hovold <johan@kernel.org>
cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/6] HID: hid-sensor-hub: use mfd_add_hotplug_devices
 helper
In-Reply-To: <1411728933-13351-6-git-send-email-johan@kernel.org>
Message-ID: <alpine.LNX.2.00.1409261325100.22196@pobox.suse.cz>
References: <1411728933-13351-1-git-send-email-johan@kernel.org> <1411728933-13351-6-git-send-email-johan@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Johan Hovold wrote:

> Use mfd_add_hotplug_devices helper to register the subdevices.
> 
> Compile-only tested.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>

As I expect this to be going through MFD tree together with the rest of 
the patchset

	Acked-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/hid-sensor-hub.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
> index 2ac25760a9a9..fbe1a6d2aa53 100644
> --- a/drivers/hid/hid-sensor-hub.c
> +++ b/drivers/hid/hid-sensor-hub.c
> @@ -641,9 +641,6 @@ static int sensor_hub_probe(struct hid_device *hdev,
>  					goto err_stop_hw;
>  			}
>  			sd->hid_sensor_hub_client_devs[
> -				sd->hid_sensor_client_cnt].id =
> -							PLATFORM_DEVID_AUTO;
> -			sd->hid_sensor_hub_client_devs[
>  				sd->hid_sensor_client_cnt].name = name;
>  			sd->hid_sensor_hub_client_devs[
>  				sd->hid_sensor_client_cnt].platform_data =
> @@ -659,8 +656,9 @@ static int sensor_hub_probe(struct hid_device *hdev,
>  	if (last_hsdev)
>  		last_hsdev->end_collection_index = i;
>  
> -	ret = mfd_add_devices(&hdev->dev, 0, sd->hid_sensor_hub_client_devs,
> -		sd->hid_sensor_client_cnt, NULL, 0, NULL);
> +	ret = mfd_add_hotplug_devices(&hdev->dev,
> +			sd->hid_sensor_hub_client_devs,
> +			sd->hid_sensor_client_cnt);
>  	if (ret < 0)
>  		goto err_stop_hw;

-- 
Jiri Kosina
SUSE Labs
