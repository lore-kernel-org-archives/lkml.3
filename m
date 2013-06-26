Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3FZGmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:42:39 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38915 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3FZGmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:42:38 -0400
MIME-Version: 1.0
Date: Wed, 26 Jun 2013 12:12:37 +0530
X-Google-Sender-Auth: uKj6LjVb40KXixDvlCeOpknbtpY
Message-ID: <CAPV97yc1xx+0hhQjVCMzPXzKHqJ70LC5V116oZvS+bh0ONyTsQ@mail.gmail.com>
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

> On Tue, Jun 25, 2013 at 04:27:18PM +0530, navin patidar wrote:
>> On Tue, Jun 25, 2013, Greg KH <gregkh@linuxfoundation.org> said:
>>
>> > On Fri, Jun 21, 2013 at 03:01:04PM +0530, navin patidar wrote:
>> >> pr_warn() is preferred over pr_warning().
>> >
>> > And dev_warn() is preferred over both of them, can you convert the code
>> > to use that instead?
>> >
>>
>> struct device is not available in usbip_start_eh()  which is required
>> for dev_warn().
>>
>> usbip_device's containers struct stub_device and struct  vhci_device
>> both have member structure usb_device but inside usbip_start_eh(), it
>> is difficult to determine  to which container struct usbip_device
>> belongs, thus container_of() can not be used here to get struct
>> usb_device.
>
> Then the code should be reworked in order to be able to properly
> determine that.
>

struct usbip_device has enum type usbip_side variable which can be
used to determine container of usbip_device.
I should have looked usbip_device struct more carefully.
sorry for previous wrong info.

regards,
--navin-patidar
