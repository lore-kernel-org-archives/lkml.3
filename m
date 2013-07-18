Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab3GRIdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:33:46 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:45978 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3GRIdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:33:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130717132736.GA7614@arwen.pp.htv.fi>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
	<20130715165209.GA6000@kroah.com>
	<CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
	<20130716063117.GA30320@kroah.com>
	<20130717075706.GC5291@arwen.pp.htv.fi>
	<CA+k=oDza-oN++KCYtVMD0V62xgkJ3ctUOmzNkaYYYhXuKtaWKQ@mail.gmail.com>
	<20130717132736.GA7614@arwen.pp.htv.fi>
Date: Thu, 18 Jul 2013 16:33:43 +0800
Message-ID: <CA+k=oDy=_CWMCfcGfy=wbhn0BDm45Y8wS=wpe6SviPcnetntTw@mail.gmail.com>
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

On Wed, Jul 17, 2013 at 9:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Jul 17, 2013 at 09:04:54PM +0800, Rong Wang wrote:
>> Hi Felipe,
>>
>> On Wed, Jul 17, 2013 at 3:57 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
>> >> > The question is since we default GADGET, so the g_mass_storage.ko is
>> >> > installed early but connecting to a host PC
>> >> > is randomly, But the udev has no idea when a host PC connects our device.
>> >> >
>> >> > So we consider it's reasonable to let the udev know the GADGET device state.
>> >> > Is there any alternative to our question?
>> >>
>> >> I thought we already export events for gadget device states, have you
>> >> looked for them?  I can't dig through the code at the moment, but this
>> >> seems like a pretty common issue...
>> >>
>> >> Felipe, any ideas?
>> >
>> > we already expose that in sysfs. IIRC udev can act on sysfs changes,
>> > no ?
>>
>> I do not know if udev can polling sysfs file content change. I'll study this.
>>
>> But the change is triggered by calling usb_gadget_set_state, and I find
>> composite framework do not call this. Then we should do this common work
>> in every udc driver?
>
> yes. Only the UDC driver knows when the controller is moving among those
> states.

OK. I got that.

But I think it may be more reasonable for the udc driver to maintain a
work queue
to handle the state change since this operation mostly happen in ISR ?


>
> --
> balbi
