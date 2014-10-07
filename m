Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaJGJZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:25:01 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:60505 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaJGJY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:24:58 -0400
Date: Tue, 7 Oct 2014 10:24:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/6] HID: hid-sensor-hub: use mfd_add_hotplug_devices
 helper
Message-ID: <20141007092452.GU25331@lee--X1>
References: <1411728933-13351-1-git-send-email-johan@kernel.org>
 <1411728933-13351-6-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411728933-13351-6-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Johan Hovold wrote:

> Use mfd_add_hotplug_devices helper to register the subdevices.
> 
> Compile-only tested.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/hid/hid-sensor-hub.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Applied for v3.19 with Jiri's Ack.

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
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
