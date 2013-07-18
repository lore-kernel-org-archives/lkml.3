Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3GRIZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:25:22 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:61615 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab3GRIZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:25:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130717023649.GD29679@nchen-desktop>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
	<20130715165209.GA6000@kroah.com>
	<CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
	<20130716063117.GA30320@kroah.com>
	<20130717023649.GD29679@nchen-desktop>
Date: Thu, 18 Jul 2013 16:25:17 +0800
Message-ID: <CA+k=oDxnHJN6NgMM_Ziz92_0d8+anfMEqz7WvBCrg5RAn9MzCg@mail.gmail.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
From: Rong Wang <wr011235813@gmail.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, balbi@ti.com,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rong.Wang@csr.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,


On Wed, Jul 17, 2013 at 10:36 AM, Peter Chen <peter.chen@freescale.com> wrote:
> On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
>> On Tue, Jul 16, 2013 at 11:49:07AM +0800, Rong Wang wrote:
>> > Hi Greg,
>> >
>> > The USB on our platform can change roles between HOST and GADGET, but
>> > it is not capable of OTG.
>>
>> That kind of sounds like the definition of OTG :)
>>
>> > When the USB changes between roles the udev will run some scripts
>> > automatically according to the udev rules.
>>
>> What exactly does udev/userspace see when the roles change?
>>
>> And what can trigger the change in roles?
>>
>> > The default role is GADGET, and we bind the g_mass_storage to the USB
>> > GADGET role.
>> >
>> > We should secure the back end file storage between the device and the
>> > host PC connecting to our device.
>> > We need to know when the GADGET is really connect to a host PC, then
>> > we can umount the file on the device
>> > and export it to the g_mass_storage.
>>
>> I thought you already get an event for this, otherwise no one would be
>> able to properly deal with this.
>>
>> > The question is since we default GADGET, so the g_mass_storage.ko is
>> > installed early but connecting to a host PC
>> > is randomly, But the udev has no idea when a host PC connects our device.
>> >
>> > So we consider it's reasonable to let the udev know the GADGET device state.
>> > Is there any alternative to our question?
>>
>> I thought we already export events for gadget device states, have you
>> looked for them?  I can't dig through the code at the moment, but this
>> seems like a pretty common issue...
>>
>
> If I understand correctly,  what Rong wants is udev can be notified the
> udc state changes, like connect/disconnect event. Currently, we only
> export it to /sys.

OK. Thanks for your share.

And you develop a new utility rather than udev to monitor that file?
And you probably create a work queue in your udc driver to do this work?

>
> --
>
> Best Regards,
> Peter Chen
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
