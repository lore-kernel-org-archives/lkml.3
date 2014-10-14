Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaJNW7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:59:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49422 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaJNW7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:59:39 -0400
Date: Tue, 14 Oct 2014 15:59:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: jkosina@suse.cz, benjamin.tissoires@redhat.com, aduggan@synaptics.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, satoshi.noguchi@jp.synaptics.com
Subject: Re: [PATCH] HID: i2c-hid: Add hid-over-i2c name to i2c id table.
Message-ID: <20141014225935.GA22177@dtor-ws>
References: <1413323041-19468-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413323041-19468-1-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 02:44:01PM -0700, Benson Leung wrote:
> When using the device tree binding of compatible = "hid-over-i2c"
> the i2c id table also needs to have that name in order to
> auto load this driver.
> 
> Signed-off-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 747d544..1a7605f 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -1123,6 +1123,7 @@ static const struct dev_pm_ops i2c_hid_pm = {
>  
>  static const struct i2c_device_id i2c_hid_id_table[] = {
>  	{ "hid", 0 },
> +	{ "hid-over-i2c", 0 },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(i2c, i2c_hid_id_table);

So we already emit this string this as a module device table (OF one),
why do we need to duplicate it in I2C? This seems like a generic problem
and not an individual driver one.

Thanks.

-- 
Dmitry
