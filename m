Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3FZF5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:57:25 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38515 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3FZF5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:57:23 -0400
MIME-Version: 1.0
Date: Wed, 26 Jun 2013 11:27:23 +0530
X-Google-Sender-Auth: vg8JJiHVzvqkH9Ct8-BYz8acKx8
Message-ID: <CAPV97yd6tZDs17cQb+3x0YpjnfOqnv=oRg-2w2hBTFpoHjxzEg@mail.gmail.com>
Subject: 
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

How about adding a usb_device pointer in  usbip_device structure ?

regards,
--navin-patidar
