Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaBUJrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 04:47:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbaBUJq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 04:46:59 -0500
Message-ID: <5307208B.8030908@redhat.com>
Date: Fri, 21 Feb 2014 10:46:51 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PWC webcam and setpwc tool no longer working with 3.12.11 kernel
References: <1392924626.38711.YahooMailNeo@web120304.mail.ne1.yahoo.com>
In-Reply-To: <1392924626.38711.YahooMailNeo@web120304.mail.ne1.yahoo.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/20/2014 08:30 PM, Chris Rankin wrote:
> 
> 
> Hi,
> 
> I have an old Logitech webcam, with USB IDs 046d:08b3. When I try to use this camera now, I see this error in the dmesg log:
> 
> [ 2883.852464] pwc: isoc_init() submit_urb 0 failed with error -28
> 
> 
> This error is apparently ENOSPC, which made me suspect that I was trying to use a mode that would require compression.

ENOSPC actually means that the data the cam is trying to send is too big for the available
bandwidth. So if anything you need to enable compression, but if compression is supported
then it will get enabled by default.

This is likely caused by the camera being plugged into a usb-bus which already is used
by other reserved-bandwidth devices such as mice, keyboard, usb soundcards, etc.

See which bus the cam is on in lsusb, and try plugging it into a different port until
it shows up on a different bus.

If possible USB-3 ports are preferred over USB-2 ports or connecting through an USB-2
hub. USB-2's USB-1 emulation has some issues, which means we cannot use full USB-1 bandwidth
there.

> However, when I tried using setpwc to configure the camera's options I received more errors:
> $ setpwc -c 3
> setpwc v1.3, (C) 2003-2006 by folkert@vanheusden.com
> Error while doing ioctl VIDIOCPWCSCQUAL: Inappropriate ioctl for device
> 
> 
> Has the kernel-to-userspace interface for PWC devices changed? Because how else could this IOCTL be "inappropriate"? Is there an alternative to setpwc, please?

Yes, the pwc driver was the only driver using its own custom ioctls instead of standard
v4l2 controls for many settings. The old ioctls have been deprecated for a while already
and have recently been removed.

You can control the camera with the v4l2-ctl app which is part of v4l-utils, or if you
want something graphical with qv4l2 which is also part of v4l-utils. More in general
any v4l controls app using the standard API-s should work, ie gtk-v4l or v4l2ucp should
work fine too.

Regards,

Hans
