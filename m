Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3A3JYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:24:01 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33721 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3A3JX7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:23:59 -0500
MIME-Version: 1.0
In-Reply-To: <87txpznkog.fsf@nemi.mork.no>
References: <1359388030-2821-1-git-send-email-dnlplm@gmail.com>
	<1359479958.1635.8.camel@dcbw.foobar.com>
	<871ud3q4sr.fsf@nemi.mork.no>
	<CAGRyCJFxe4sg_GhimQjTG+jSb8CYJRP3wGcJDEJSq6Uek0Y_iQ@mail.gmail.com>
	<87txpznkog.fsf@nemi.mork.no>
Date: Wed, 30 Jan 2013 10:23:57 +0100
Message-ID: <CAGRyCJFgk5bYgY28tPo3UD8CvAM0cAVsY6bXkK=KEh4HhPy2_A@mail.gmail.com>
Subject: Re: [PATCH 1/1] USB: option: add support for Telit LE920
From: Daniele Palmas <dnlplm@gmail.com>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Urlichs <smurf@smurf.noris.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/30 Bjørn Mork <bjorn@mork.no>:
> Daniele Palmas <dnlplm@gmail.com> writes:
>
>> The output of lsusb for interface #1 is the following:
>>
>> Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        1
>>       bAlternateSetting       0
>>       bNumEndpoints           2
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass     66
>>       bInterfaceProtocol      1
>>       iInterface              0
>>
>> It should be an adb device, so probably it is not needed to blacklist
>> it. Should I resend a new patch with only interface #5 reserved?
>
> You could have used USB_DEVICE_AND_INTERFACE_INFO() matching on all
> ff/ff/ff to avoid blacklisting the adb interface, but IMHO the patch is
> fine as it is.
>

Thanks, next time I'll follow that way.

> This being an Android device raises another question though: Are these
> interface numbers static?  I assume you can e.g. disable adb?  What
> happens to the descriptors then?  Does the device change pid, or are the
> interfaces renumbered?
>

This is the device:

http://www.telit.com/en/products/lte.php?p_id=421&p_ac=show&p=130

It is not an Android device, but an AT command based modem. I don't
really know why there is an adb interface, but I am quite sure that
you cannot disable it and the interface numbers should be static.

However, if I find that this is not true, I will take care of sending
a new set of patches for addressing the issue.

Regards,
Daniele
