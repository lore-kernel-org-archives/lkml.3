Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaBMVdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:33:00 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:46474 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBMVc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:32:58 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 13 Feb 2014 13:20:16 -0800
Message-ID: <52FD3A06.6050601@synaptics.com>
Date: Thu, 13 Feb 2014 13:32:54 -0800
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
Subject: Re: [PATCH 07/11] Input: synaptics-rmi4 - rename instances of f01_data
 from data to f01
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com> <1392269277-16391-7-git-send-email-dmitry.torokhov@gmail.com>
In-Reply-To: <1392269277-16391-7-git-send-email-dmitry.torokhov@gmail.com>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
> We have too many "data"s: f01_data, driver_data, pdata, etc. Let's
> untangle it a bit.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Christopher Heiny <cheiny@synaptics.com>

> ---
>   drivers/input/rmi4/rmi_f01.c | 135 ++++++++++++++++++++++---------------------
>   1 file changed, 68 insertions(+), 67 deletions(-)
>
> diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
> index 1e49ab4..1219e0c 100644
> --- a/drivers/input/rmi4/rmi_f01.c
> +++ b/drivers/input/rmi4/rmi_f01.c
> @@ -208,7 +208,7 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   	u16 ctrl_base_addr;
>   	struct rmi_device *rmi_dev = fn->rmi_dev;
>   	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
> -	struct f01_data *data = fn->data;
> +	struct f01_data *f01 = fn->data;
>   	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
>   	u8 device_status;
>
> @@ -218,8 +218,8 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   	 */
>   	ctrl_base_addr = fn->fd.control_base_addr;
>   	error = rmi_read_block(rmi_dev, fn->fd.control_base_addr,
> -			&data->device_control.ctrl0,
> -			sizeof(data->device_control.ctrl0));
> +			&f01->device_control.ctrl0,
> +			sizeof(f01->device_control.ctrl0));
>   	if (error < 0) {
>   		dev_err(&fn->dev, "Failed to read F01 control.\n");
>   		return error;
> @@ -228,10 +228,10 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   	case RMI_F01_NOSLEEP_DEFAULT:
>   		break;
>   	case RMI_F01_NOSLEEP_OFF:
> -		data->device_control.ctrl0 &= ~RMI_F01_CRTL0_NOSLEEP_BIT;
> +		f01->device_control.ctrl0 &= ~RMI_F01_CRTL0_NOSLEEP_BIT;
>   		break;
>   	case RMI_F01_NOSLEEP_ON:
> -		data->device_control.ctrl0 |= RMI_F01_CRTL0_NOSLEEP_BIT;
> +		f01->device_control.ctrl0 |= RMI_F01_CRTL0_NOSLEEP_BIT;
>   		break;
>   	}
>
> @@ -240,38 +240,38 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   	 * reboot without power cycle.  If so, clear it so the sensor
>   	 * is certain to function.
>   	 */
> -	if ((data->device_control.ctrl0 & RMI_F01_CTRL0_SLEEP_MODE_MASK) !=
> +	if ((f01->device_control.ctrl0 & RMI_F01_CTRL0_SLEEP_MODE_MASK) !=
>   			RMI_SLEEP_MODE_NORMAL) {
>   		dev_warn(&fn->dev,
>   			 "WARNING: Non-zero sleep mode found. Clearing...\n");
> -		data->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
> +		f01->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
>   	}
>
> -	data->device_control.ctrl0 |= RMI_F01_CRTL0_CONFIGURED_BIT;
> +	f01->device_control.ctrl0 |= RMI_F01_CRTL0_CONFIGURED_BIT;
>
>   	error = rmi_write_block(rmi_dev, fn->fd.control_base_addr,
> -				&data->device_control.ctrl0,
> -				sizeof(data->device_control.ctrl0));
> +				&f01->device_control.ctrl0,
> +				sizeof(f01->device_control.ctrl0));
>   	if (error < 0) {
>   		dev_err(&fn->dev, "Failed to write F01 control.\n");
>   		return error;
>   	}
>
> -	data->irq_count = driver_data->irq_count;
> -	data->num_of_irq_regs = driver_data->num_of_irq_regs;
> +	f01->irq_count = driver_data->irq_count;
> +	f01->num_of_irq_regs = driver_data->num_of_irq_regs;
>   	ctrl_base_addr += sizeof(u8);
>
> -	data->interrupt_enable_addr = ctrl_base_addr;
> +	f01->interrupt_enable_addr = ctrl_base_addr;
>   	error = rmi_read_block(rmi_dev, ctrl_base_addr,
> -				data->device_control.interrupt_enable,
> -				sizeof(u8) * (data->num_of_irq_regs));
> +				f01->device_control.interrupt_enable,
> +				sizeof(u8) * (f01->num_of_irq_regs));
>   	if (error < 0) {
>   		dev_err(&fn->dev,
>   			"Failed to read F01 control interrupt enable register.\n");
>   		return error;
>   	}
>
> -	ctrl_base_addr += data->num_of_irq_regs;
> +	ctrl_base_addr += f01->num_of_irq_regs;
>
>   	/* dummy read in order to clear irqs */
>   	error = rmi_read(rmi_dev, fn->fd.data_base_addr + 1, &temp);
> @@ -281,42 +281,42 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   	}
>
>   	error = rmi_f01_read_properties(rmi_dev, fn->fd.query_base_addr,
> -					&data->properties);
> +					&f01->properties);
>   	if (error < 0) {
>   		dev_err(&fn->dev, "Failed to read F01 properties.\n");
>   		return error;
>   	}
>   	dev_info(&fn->dev, "found RMI device, manufacturer: %s, product: %s\n",
> -		 data->properties.manufacturer_id == 1 ?
> +		 f01->properties.manufacturer_id == 1 ?
>   							"Synaptics" : "unknown",
> -		 data->properties.product_id);
> +		 f01->properties.product_id);
>
>   	/* read control register */
> -	if (data->properties.has_adjustable_doze) {
> -		data->doze_interval_addr = ctrl_base_addr;
> +	if (f01->properties.has_adjustable_doze) {
> +		f01->doze_interval_addr = ctrl_base_addr;
>   		ctrl_base_addr++;
>
>   		if (pdata->power_management.doze_interval) {
> -			data->device_control.doze_interval =
> +			f01->device_control.doze_interval =
>   				pdata->power_management.doze_interval;
>   		} else {
> -			error = rmi_read(rmi_dev, data->doze_interval_addr,
> -					&data->device_control.doze_interval);
> +			error = rmi_read(rmi_dev, f01->doze_interval_addr,
> +					 &f01->device_control.doze_interval);
>   			if (error < 0) {
>   				dev_err(&fn->dev, "Failed to read F01 doze interval register.\n");
>   				return error;
>   			}
>   		}
>
> -		data->wakeup_threshold_addr = ctrl_base_addr;
> +		f01->wakeup_threshold_addr = ctrl_base_addr;
>   		ctrl_base_addr++;
>
>   		if (pdata->power_management.wakeup_threshold) {
> -			data->device_control.wakeup_threshold =
> +			f01->device_control.wakeup_threshold =
>   				pdata->power_management.wakeup_threshold;
>   		} else {
> -			error = rmi_read(rmi_dev, data->wakeup_threshold_addr,
> -					&data->device_control.wakeup_threshold);
> +			error = rmi_read(rmi_dev, f01->wakeup_threshold_addr,
> +					 &f01->device_control.wakeup_threshold);
>   			if (error < 0) {
>   				dev_err(&fn->dev, "Failed to read F01 wakeup threshold register.\n");
>   				return error;
> @@ -324,19 +324,19 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   		}
>   	}
>
> -	if (data->properties.has_lts)
> +	if (f01->properties.has_lts)
>   		ctrl_base_addr++;
>
> -	if (data->properties.has_adjustable_doze_holdoff) {
> -		data->doze_holdoff_addr = ctrl_base_addr;
> +	if (f01->properties.has_adjustable_doze_holdoff) {
> +		f01->doze_holdoff_addr = ctrl_base_addr;
>   		ctrl_base_addr++;
>
>   		if (pdata->power_management.doze_holdoff) {
> -			data->device_control.doze_holdoff =
> +			f01->device_control.doze_holdoff =
>   				pdata->power_management.doze_holdoff;
>   		} else {
> -			error = rmi_read(rmi_dev, data->doze_holdoff_addr,
> -					&data->device_control.doze_holdoff);
> +			error = rmi_read(rmi_dev, f01->doze_holdoff_addr,
> +					 &f01->device_control.doze_holdoff);
>   			if (error < 0) {
>   				dev_err(&fn->dev, "Failed to read F01 doze holdoff register.\n");
>   				return error;
> @@ -363,28 +363,28 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>
>   static int rmi_f01_config(struct rmi_function *fn)
>   {
> -	struct f01_data *data = fn->data;
> +	struct f01_data *f01 = fn->data;
>   	int retval;
>
>   	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
> -				 &data->device_control.ctrl0,
> -				 sizeof(data->device_control.ctrl0));
> +				 &f01->device_control.ctrl0,
> +				 sizeof(f01->device_control.ctrl0));
>   	if (retval < 0) {
>   		dev_err(&fn->dev, "Failed to write device_control.reg.\n");
>   		return retval;
>   	}
>
> -	retval = rmi_write_block(fn->rmi_dev, data->interrupt_enable_addr,
> -				 data->device_control.interrupt_enable,
> -				 sizeof(u8) * data->num_of_irq_regs);
> -
> +	retval = rmi_write_block(fn->rmi_dev, f01->interrupt_enable_addr,
> +				 f01->device_control.interrupt_enable,
> +				 sizeof(u8) * f01->num_of_irq_regs);
>   	if (retval < 0) {
>   		dev_err(&fn->dev, "Failed to write interrupt enable.\n");
>   		return retval;
>   	}
> -	if (data->properties.has_adjustable_doze) {
> -		retval = rmi_write_block(fn->rmi_dev, data->doze_interval_addr,
> -					 &data->device_control.doze_interval,
> +
> +	if (f01->properties.has_adjustable_doze) {
> +		retval = rmi_write_block(fn->rmi_dev, f01->doze_interval_addr,
> +					 &f01->device_control.doze_interval,
>   					 sizeof(u8));
>   		if (retval < 0) {
>   			dev_err(&fn->dev, "Failed to write doze interval.\n");
> @@ -392,8 +392,8 @@ static int rmi_f01_config(struct rmi_function *fn)
>   		}
>
>   		retval = rmi_write_block(fn->rmi_dev,
> -					 data->wakeup_threshold_addr,
> -					 &data->device_control.wakeup_threshold,
> +					 f01->wakeup_threshold_addr,
> +					 &f01->device_control.wakeup_threshold,
>   					 sizeof(u8));
>   		if (retval < 0) {
>   			dev_err(&fn->dev, "Failed to write wakeup threshold.\n");
> @@ -401,15 +401,16 @@ static int rmi_f01_config(struct rmi_function *fn)
>   		}
>   	}
>
> -	if (data->properties.has_adjustable_doze_holdoff) {
> -		retval = rmi_write_block(fn->rmi_dev, data->doze_holdoff_addr,
> -					 &data->device_control.doze_holdoff,
> +	if (f01->properties.has_adjustable_doze_holdoff) {
> +		retval = rmi_write_block(fn->rmi_dev, f01->doze_holdoff_addr,
> +					 &f01->device_control.doze_holdoff,
>   					 sizeof(u8));
>   		if (retval < 0) {
>   			dev_err(&fn->dev, "Failed to write doze holdoff.\n");
>   			return retval;
>   		}
>   	}
> +
>   	return 0;
>   }
>
> @@ -435,28 +436,28 @@ static int rmi_f01_suspend(struct device *dev)
>   {
>   	struct rmi_function *fn = to_rmi_function(dev);
>   	struct rmi_device *rmi_dev = fn->rmi_dev;
> -	struct f01_data *data = fn->data;
> +	struct f01_data *f01 = fn->data;
>   	int error;
>
> -	data->old_nosleep = data->device_control.ctrl0 &
> +	f01->old_nosleep = f01->device_control.ctrl0 &
>   					RMI_F01_CRTL0_NOSLEEP_BIT;
> -	data->device_control.ctrl0 &= ~RMI_F01_CRTL0_NOSLEEP_BIT;
> +	f01->device_control.ctrl0 &= ~RMI_F01_CRTL0_NOSLEEP_BIT;
>
> -	data->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
> -	data->device_control.ctrl0 |= RMI_SLEEP_MODE_SENSOR_SLEEP;
> +	f01->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
> +	f01->device_control.ctrl0 |= RMI_SLEEP_MODE_SENSOR_SLEEP;
>
>   	error = rmi_write_block(rmi_dev,
>   				fn->fd.control_base_addr,
> -				&data->device_control.ctrl0,
> -				sizeof(data->device_control.ctrl0));
> +				&f01->device_control.ctrl0,
> +				sizeof(f01->device_control.ctrl0));
>   	if (error < 0) {
>   		dev_err(&fn->dev, "Failed to write sleep mode. Code: %d.\n",
>   			error);
> -		if (data->old_nosleep)
> -			data->device_control.ctrl0 |=
> +		if (f01->old_nosleep)
> +			f01->device_control.ctrl0 |=
>   					RMI_F01_CRTL0_NOSLEEP_BIT;
> -		data->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
> -		data->device_control.ctrl0 |= RMI_SLEEP_MODE_NORMAL;
> +		f01->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
> +		f01->device_control.ctrl0 |= RMI_SLEEP_MODE_NORMAL;
>   		return error;
>   	}
>
> @@ -467,18 +468,18 @@ static int rmi_f01_resume(struct device *dev)
>   {
>   	struct rmi_function *fn = to_rmi_function(dev);
>   	struct rmi_device *rmi_dev = fn->rmi_dev;
> -	struct f01_data *data = fn->data;
> +	struct f01_data *f01 = fn->data;
>   	int error;
>
> -	if (data->old_nosleep)
> -		data->device_control.ctrl0 |= RMI_F01_CRTL0_NOSLEEP_BIT;
> +	if (f01->old_nosleep)
> +		f01->device_control.ctrl0 |= RMI_F01_CRTL0_NOSLEEP_BIT;
>
> -	data->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
> -	data->device_control.ctrl0 |= RMI_SLEEP_MODE_NORMAL;
> +	f01->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
> +	f01->device_control.ctrl0 |= RMI_SLEEP_MODE_NORMAL;
>
>   	error = rmi_write_block(rmi_dev, fn->fd.control_base_addr,
> -				&data->device_control.ctrl0,
> -				sizeof(data->device_control.ctrl0));
> +				&f01->device_control.ctrl0,
> +				sizeof(f01->device_control.ctrl0));
>   	if (error < 0) {
>   		dev_err(&fn->dev,
>   			"Failed to restore normal operation. Code: %d.\n",
>


-- 

Christopher Heiny
Senior Staff Firmware Engineer
Synaptics Incorporated
