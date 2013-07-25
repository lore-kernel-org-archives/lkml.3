Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3GYF4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 01:56:53 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51096 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3GYF4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 01:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130725043741.GA11906@kroah.com>
References: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
	<1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
	<20130724215340.GY5585@mwanda>
	<20130724220631.GA10541@kroah.com>
	<CABe_0=+bXAuXhG+XG4ObUO_2MYD_XWxF_wbTVrpKagmHi8_CDQ@mail.gmail.com>
	<20130725043741.GA11906@kroah.com>
Date: Thu, 25 Jul 2013 14:56:51 +0900
Message-ID: <CABe_0=JCfq3pHvmQK42NQd16JRj-xjXP=jLvN5QCk-k8KH199w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] staging: gdm7240: adding LTE USB driver
From: Won Kang <wkang77@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        wonkang@gctsemi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> GDM7240 is in LE where as GDM7243 (currently under development) is in BE.
>
> But why does this information need to be sent to userspace?
>

GDM724x chips have different endianess because of their internal
architecture.The device sends out and accepts LTE protocol information
in its own endianess. This is the design decision we made and we let
the host converts the byte order. To decode the protocols, userspace
needs this endianess information.

>> User space applications needs to discover the endianess to properly
>> encode/decode LTE control protocols. We have existing customers
>> already deploying units in large volume, and want to avoid forcing
>> them to change SDK APIs along with kernel updates.
>> At some point, It will have to be fixed with SDK API can interoperate properly.
>
> Ugh, really?  What special tools does userspace need to talk to this
> device?  It "should" just be a network device, and a serial port, why
> does the endianness of the device mean anything?

Just like 3G modems, network device and a serial port is enough for
basic operation. For this, no ioctl for endianess is required.
However, customers and operators want more information and programming
capabilities, and this is really difficult to achieve with standard
3GPP AT commands alone. Therefore, if wanted, we also provide SDK APIs
for handling more advanced features. Examples of such information
include detailed connection status, rf controls, debug logs, and even
firmware download.

> Custom ioctls aren't ok for new drivers, if at all possible.  Can't
> userspace just trigger this based on the device id instead?

Historically, the SDK is cross-platform designed and we wanted to have
common methods for different operating systems, and have chosen to use
ioctl. Windows does have one :). We will probably go with reading
device id

Anyway, you are right that endianess matters only when using this SDK.
If you suggest to remove the ioctl because SDK is optional, I will
agree.

Regards,
Won.
