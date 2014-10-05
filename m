Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaJEJXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:23:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaJEJXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:23:08 -0400
Message-ID: <54310DF9.8070904@redhat.com>
Date: Sun, 05 Oct 2014 11:23:05 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>, linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: uas: module not loaded automatically
References: <54303DF6.4050203@web.de> <54310A74.3090404@redhat.com> <54310C04.5060008@web.de>
In-Reply-To: <54310C04.5060008@web.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/05/2014 11:14 AM, Jan Kiszka wrote:
> On 2014-10-05 11:08, Hans de Goede wrote:
>> Hi,
>>
>> On 10/04/2014 08:35 PM, Jan Kiszka wrote:
>>> Hi,
>>>
>>> my Delock external USB drive stopped working after updating from a
>>> UAS-disabled distro kernel to latest 3.17-rc7 with UAS on. That UAS was
>>> key became clear to me only after looking at storage_probe(): the device
>>> is ignored by usb-storage if it is UAS-capable. However, nothing causes
>>> uas.ko to be loaded when the drive is plugged here. How is this supposed
>>> to work in the normal case?
>>
>> Is the uas.ko module installed, and was depmod run after installing it ?
> 
> Definitely. Just retried after another depmod -a, and only modprobe uas
> made it work.
> 
>>
>> uas.c has the following:
>>
>>         { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_BULK) },
>>         { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_UAS) },
>>
>> Which should make it load automatically on your device.
> 
> Should this match with what lsusb -v reports for the device? 

Yes, and it does, for both alt settings of your device:

      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only

      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     98

Where 98 == USB_PR_UAS, seems you have an quite old lsusb if it does not
know that though. Could it be the rest of your userspace is old too, and is
not smart enough to load all matching drivers, instead only loading the first matching
driver (which happens to be usb-storage) ?

Regards,

Hans
