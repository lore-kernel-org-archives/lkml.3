Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaAEGJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 01:09:24 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57166 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaAEGJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 01:09:23 -0500
Date: Sat, 4 Jan 2014 22:09:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: hans.verkuil@cisco.com, m.chehab@samsung.com, gregkh@linuxfoundation.org,
        mchehab@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] cx18: introduce a helper function to void array
 overrun
Message-ID: <20140105060920.GE18213@core.coreip.homeip.net>
References: <1388884659-693-1-git-send-email-ethan.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388884659-693-1-git-send-email-ethan.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ethan,

On Sun, Jan 05, 2014 at 09:17:39AM +0800, Ethan Zhao wrote:
> cx18_i2c_register() is called in cx18_init_subdevs() with index
> greater than length of hw_bus array, that will cause array overrun,
> introduce a helper cx18_get_max_bus_num() to void it.

s/void/avoid/

> 
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  drivers/media/pci/cx18/cx18-driver.c | 2 +-
>  drivers/media/pci/cx18/cx18-i2c.c    | 5 +++++
>  drivers/media/pci/cx18/cx18-i2c.h    | 1 +
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> index 6386ced..dadcd4a 100644
> --- a/drivers/media/pci/cx18/cx18-driver.c
> +++ b/drivers/media/pci/cx18/cx18-driver.c
> @@ -856,7 +856,7 @@ static void cx18_init_subdevs(struct cx18 *cx)
>  	u32 device;
>  	int i;
>  
> -	for (i = 0, device = 1; i < 32; i++, device <<= 1) {
> +	for (i = 0, device = 1; i < cx18_get_max_bus_num(); i++, device <<= 1) {
>  
>  		if (!(device & hw))
>  			continue;
> diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
> index 4af8cd6..e0e8193 100644
> --- a/drivers/media/pci/cx18/cx18-i2c.c
> +++ b/drivers/media/pci/cx18/cx18-i2c.c
> @@ -108,6 +108,11 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
>  	       -1 : 0;
>  }
>  
> +int cx18_get_max_bus_num()

This should be "int cx18_get_max_bus_num(void)" since we are using C and
not C++.

> +{
> +	return sizeof(hw_bus);

I'd rather see

	return ARRAY_SIZE(hw_bus);

Thanks.

-- 
Dmitry
