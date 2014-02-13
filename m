Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaBMVPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:15:46 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:47782 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaBMVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:15:45 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 13 Feb 2014 13:03:02 -0800
Message-ID: <52FD35FC.1060706@synaptics.com>
Date: Thu, 13 Feb 2014 13:15:40 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/11] Input: synaptics-rmi4 - remove device_status form
 f01_data
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com> <1392269277-16391-6-git-send-email-dmitry.torokhov@gmail.com>
In-Reply-To: <1392269277-16391-6-git-send-email-dmitry.torokhov@gmail.com>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
> We do not need to persist it - we read it when signalled.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Christopher Heiny <cheiny@synaptics.com>

> ---
>   drivers/input/rmi4/rmi_f01.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
> index 6f90a6c..1e49ab4 100644
> --- a/drivers/input/rmi4/rmi_f01.c
> +++ b/drivers/input/rmi4/rmi_f01.c
> @@ -126,8 +126,6 @@ struct f01_data {
>
>   	struct f01_device_control device_control;
>
> -	u8 device_status;
> -
>   	u16 interrupt_enable_addr;
>   	u16 doze_interval_addr;
>   	u16 wakeup_threshold_addr;
> @@ -212,6 +210,7 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
>   	struct f01_data *data = fn->data;
>   	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
> +	u8 device_status;
>
>   	/*
>   	 * Set the configured bit and (optionally) other important stuff
> @@ -346,16 +345,16 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   	}
>
>   	error = rmi_read_block(rmi_dev, fn->fd.data_base_addr,
> -		&data->device_status, sizeof(data->device_status));
> +		&device_status, sizeof(device_status));
>   	if (error < 0) {
>   		dev_err(&fn->dev, "Failed to read device status.\n");
>   		return error;
>   	}
>
> -	if (RMI_F01_STATUS_UNCONFIGURED(data->device_status)) {
> +	if (RMI_F01_STATUS_UNCONFIGURED(device_status)) {
>   		dev_err(&fn->dev,
>   			"Device was reset during configuration process, status: %#02x!\n",
> -			RMI_F01_STATUS_CODE(data->device_status));
> +			RMI_F01_STATUS_CODE(device_status));
>   		return -EINVAL;
>   	}
>
> @@ -497,18 +496,18 @@ static int rmi_f01_attention(struct rmi_function *fn,
>   			     unsigned long *irq_bits)
>   {
>   	struct rmi_device *rmi_dev = fn->rmi_dev;
> -	struct f01_data *data = fn->data;
>   	int retval;
> +	u8 device_status;
>
>   	retval = rmi_read_block(rmi_dev, fn->fd.data_base_addr,
> -		&data->device_status, sizeof(data->device_status));
> +		&device_status, sizeof(device_status));
>   	if (retval < 0) {
>   		dev_err(&fn->dev, "Failed to read device status, code: %d.\n",
>   			retval);
>   		return retval;
>   	}
>
> -	if (RMI_F01_STATUS_UNCONFIGURED(data->device_status)) {
> +	if (RMI_F01_STATUS_UNCONFIGURED(device_status)) {
>   		dev_warn(&fn->dev, "Device reset detected.\n");
>   		retval = rmi_dev->driver->reset_handler(rmi_dev);
>   		if (retval < 0)
>


-- 

Christopher Heiny
Senior Staff Firmware Engineer
Synaptics Incorporated
