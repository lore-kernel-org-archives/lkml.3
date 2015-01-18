Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbbARSzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:55:55 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbARSzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:55:52 -0500
Date: Sun, 18 Jan 2015 10:55:51 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] toshiba_acpi: Add support for USB Sleep and Charge
 function
Message-ID: <20150118185551.GF56582@vmdeb7>
References: <1421271621-8330-1-git-send-email-coproscefalo@gmail.com>
 <1421271621-8330-2-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421271621-8330-2-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 02:40:18PM -0700, Azael Avalos wrote:
> Newer Toshiba models now come with a feature called Sleep and Charge,
> where the computer USB ports remain powered when the computer is
> asleep or turned off.
> 
> This patch adds support to such feature, creating a sysfs entry
> called "usb_sleep_charge" to set the desired charging mode or to
> disable it.
> 
> The sysfs entry accepts three parameters, 0x0, 0x9 and 0x21, beign
> disabled, alternate and auto respectively.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
>  drivers/platform/x86/toshiba_acpi.c | 112 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 112 insertions(+)
...

> +static ssize_t toshiba_usb_sleep_charge_store(struct device *dev,
> +					      struct device_attribute *attr,
> +					      const char *buf, size_t count)
> +{
> +	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
> +	int state;
> +	int ret;
> +
> +	ret = kstrtoint(buf, 0, &state);
> +	if (ret)
> +		return ret;
> +
> +	/* Set the USB charging mode where:
> +	 * 0x30000 - Disable
> +	 * 0x30009 - Alternate
> +	 * 0x30021 - Auto
> +	 */
> +	state |= 0x30000;
> +	if (state != SCI_USB_CHARGE_DISABLED && state != SCI_USB_CHARGE_AUTO &&
> +	    state != SCI_USB_CHARGE_ALTERNATE)
> +		return -EINVAL;

Sorry, I missed this as the input validation on my first pass. Looks good.

-- 
Darren Hart
Intel Open Source Technology Center
