Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3FYK5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:57:20 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:49671 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3FYK5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:57:19 -0400
MIME-Version: 1.0
Date: Tue, 25 Jun 2013 16:27:18 +0530
X-Google-Sender-Auth: DWKknAbFyy07euxBntH0OV-f6S0
Message-ID: <CAPV97yePEe4K_yLKjvY2fmjgeL_xvbka=qi-EsoSJasmFtidVg@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: replace pr_warning() with pr_warn()
From: navin patidar <navinp@cdac.in>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: mfm@muteddisk.com, linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013, Greg KH <gregkh@linuxfoundation.org> said:

> On Fri, Jun 21, 2013 at 03:01:04PM +0530, navin patidar wrote:
>> pr_warn() is preferred over pr_warning().
>
> And dev_warn() is preferred over both of them, can you convert the code
> to use that instead?
>

struct device is not available in usbip_start_eh()  which is required
for dev_warn().

usbip_device's containers struct stub_device and struct  vhci_device
both have member structure usb_device but inside usbip_start_eh(), it
is difficult to determine  to which container struct usbip_device
belongs, thus container_of() can not be used here to get struct
usb_device.


regards,
--navin-patidar
