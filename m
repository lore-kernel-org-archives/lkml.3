Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaC1H7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:59:50 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:46214 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaC1H7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:59:48 -0400
Date: Fri, 28 Mar 2014 07:59:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Oliver Neukum <oneukum@suse.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Subject: Re: [PATCH v5 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140328075942.GD17779@lee--X1>
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com>
 <1395744293-24398-2-git-send-email-rogerable@realtek.com>
 <201403280231.s2S2VP8X017745@rtits1.realtek.com>
 <5334ED70.6050309@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5334ED70.6050309@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> >>+static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
> >>+{
> >>+	struct rtsx_ucr *ucr =
> >>+		(struct rtsx_ucr *)usb_get_intfdata(intf);
> >>+
> >>+	dev_dbg(&intf->dev, "%s called with pm message 0x%04u\n",
> >>+			__func__, message.event);
> >>+
> >>+	mutex_lock(&ucr->dev_mutex);
> >>+	rtsx_usb_turn_off_led(ucr);
> >
> >When is this turned on again?
> >
> 
> The LED is not in a permanent cut-off state after here. It is called
> to guarantee the LED is off during suspend to save more power. It
> could be lit up in the card host drivers(e.g. rtsx_usb_sdmmc.c)
> anytime whenever necessary.
> 
> This has been asked may times. I'm considering putting some comment
> in next revision.

Yes, please do.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
