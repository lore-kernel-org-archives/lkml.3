Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaGVIhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:37:07 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48791 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaGVIhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:37:01 -0400
Date: Tue, 22 Jul 2014 09:36:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei-Chun Pan <weichun.pan@advantech.com.tw>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        "Louis.Lu" <Louis.Lu@advantech.com.tw>,
        "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mfd: imanager2: Add Advantech EC APIs support for
 IT8516/18/28
Message-ID: <20140722083655.GE28529@lee--X1>
References: <1405342486-17031-1-git-send-email-weichun.pan@advantech.com.tw>
 <1405342486-17031-2-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405342486-17031-2-git-send-email-weichun.pan@advantech.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Wei-Chun Pan wrote:

You have to write a commit log here.  What is this?  Why is it needed?
What problem does it solve?  What happens if it's not provided?  How
is it implemented?  Etc etc.

> Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
> ---
>  drivers/mfd/imanager2_ec.c | 615 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 615 insertions(+)
>  create mode 100644 drivers/mfd/imanager2_ec.c
> 
> diff --git a/drivers/mfd/imanager2_ec.c b/drivers/mfd/imanager2_ec.c
> new file mode 100644
> index 0000000..f7a0003
> --- /dev/null
> +++ b/drivers/mfd/imanager2_ec.c
> @@ -0,0 +1,615 @@
> +/*
> + * imanager2_ec.c - MFD accessing driver of Advantech EC IT8516/18/28
> + * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.

I'd prefer if you used the short version.

> + */
> +
> +#include <linux/io.h>
> +#include <linux/delay.h>

I'm sure that you're missing a whole bunch of header files here.  You
are to include all files that you make use of in _this_ file.

> +#include <linux/mfd/imanager2_ec.h>

Comment this line out to see what is not defined.  At the very least
you will need export.h and err.h.

[...]

> +static int imanager2_read_mailbox(u32 ecflag, u8 offset, u8 *data)
> +{
> +	if (ecflag & EC_FLAG_IO_MAILBOX) {
> +		int ret = ec_wait_ibc0();
> +		if (ret)
> +			return ret;
> +		inb(EC_IO_PORT_DATA);
> +		outb(offset + EC_IO_CMD_READ_OFFSET, EC_IO_PORT_CMD);
> +
> +		return ec_inb_after_obf1(data);
> +	} else {
> +		outb(offset, EC_ITE_PORT_OFS);
> +		*data = inb(EC_ITE_PORT_DATA);
> +	}
> +
> +	return 0;
> +}

All of the Mailbox controller code in this file should live in
drivers/mailbox.

Also, does your Mailbox controller support IRQs?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
