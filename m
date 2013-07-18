Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab3GRKyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:54:40 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51053 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab3GRKyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130718101058.GG11251@arwen.pp.htv.fi>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
	<20130715165209.GA6000@kroah.com>
	<CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
	<20130716063117.GA30320@kroah.com>
	<20130717075706.GC5291@arwen.pp.htv.fi>
	<CA+k=oDza-oN++KCYtVMD0V62xgkJ3ctUOmzNkaYYYhXuKtaWKQ@mail.gmail.com>
	<20130717132736.GA7614@arwen.pp.htv.fi>
	<CA+k=oDy=_CWMCfcGfy=wbhn0BDm45Y8wS=wpe6SviPcnetntTw@mail.gmail.com>
	<20130718084041.GE11251@arwen.pp.htv.fi>
	<CA+k=oDxbu09FoQdOVUQhK-Q4hKuPYyiYDS1akoE2kggN7echgA@mail.gmail.com>
	<20130718101058.GG11251@arwen.pp.htv.fi>
Date: Thu, 18 Jul 2013 18:54:38 +0800
Message-ID: <CA+k=oDwvA3eSy7xL7hyBVgjCm37Mv7iroFndJOC09ZQci0=o0A@mail.gmail.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
From: Rong Wang <wr011235813@gmail.com>
To: balbi@ti.com
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rong.Wang@csr.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Here's the patch. If you are OK with it, I'll send it to the list formally.
Thanks.

-------------------------------------------------------------------------------------------------

usb: gadget: udc-core: make udc state attribute name consistent

The name of udc state attribute file under sysfs is
registered as "state", while usb_gadget_set_state
take it as "status" when it's going to update.
Here it is made consistent as "state".

Signed-off-by: Rong Wang <Rong.Wang@csr.com>

diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index ffd8fa5..5514822 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -105,7 +105,7 @@ void usb_gadget_set_state(struct usb_gadget *gadget,
                enum usb_device_state state)
 {
        gadget->state = state;
-       sysfs_notify(&gadget->dev.kobj, NULL, "status");
+      sysfs_notify(&gadget->dev.kobj, NULL, "state");
 }
 EXPORT_SYMBOL_GPL(usb_gadget_set_state);

On Thu, Jul 18, 2013 at 6:10 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Jul 18, 2013 at 05:28:19PM +0800, Rong Wang wrote:
>> Hi Felipe,
>>
>> Thanks, I'll test the patch.
>>
>> But sysfs_notify(&gadget->dev.kobj, NULL, "status"), status or state ?
>> I notice that DEVICE_ATTR(state, S_IRUGO, usb_gadget_state_show, NULL)
>
> good eyes, please send a patch which I'll queue on this -rc and Cc:
> <stable@vger.kernel.org>.
>
> I'll rewrite my patch on top of the patched -rc later.
>
> --
> balbi
