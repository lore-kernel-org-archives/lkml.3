Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaIYOW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:22:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55680 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaIYOW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:22:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAH6sp9NzuEvP8zTRFi1bB8B6Xe08tmv7JbHMjQdvC2NSg9RBGw@mail.gmail.com>
References: <53F878AD.1000408@schreyben.de>
	<CAH6sp9NzuEvP8zTRFi1bB8B6Xe08tmv7JbHMjQdvC2NSg9RBGw@mail.gmail.com>
Date: Thu, 25 Sep 2014 16:22:26 +0200
Message-ID: <CAH6sp9NN1W6VWTuuwRkW2wjhzrXuXf86N6CR67uQKJnShDEvrA@mail.gmail.com>
Subject: Re: linux-stable: backport usb related commit to 3.10 and 3.12?
From: Frans Klaver <fransklaver@gmail.com>
To: Schrey <debian-kernel@schreyben.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 4:20 PM, Frans Klaver <fransklaver@gmail.com> wrote:
> On Sat, Aug 23, 2014 at 1:19 PM, Schrey <debian-kernel@schreyben.de> wrote:
>> Greetings.
>>
>> On an administered server, I noticed that there's a constant load
>> around 0.70 when running kernels 3.10 and 3.12, even if
>> the system is doing nothing, and in single user mode.
>> Culprit seems to be the process 'khubd'.
>> No such effect when running kernels 3.4 or 3.14.
>>
>> I reverse bisected linux-stable and found that the following commit
>> fixes it for me, for both kernel 3.10 and 3.12:
>>
>> [08d1dec6f4054e3613f32051d9b149d4203ce0d2] usb:hub set hub->change_bits when
>> over-current happens
>>
>>
>> Could that commit be backported to the stable 3.10 and 3.12 series?
>>
>> (Disclaimer: I'm not a programmer, but I'd be happy to help with any testing
>> involved)
>>
>> Regards
>> Ingmar
>>
>> --------------------------------------------------------------------------
>>
>> $ git diff ac5166bcdb43889a5bd837f5076b78049e1f8bca
>> 08d1dec6f4054e3613f32051d9b149d4203ce0d2
>> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
>> index c1422a0..babba88 100644
>> --- a/drivers/usb/core/hub.c
>> +++ b/drivers/usb/core/hub.c
>> @@ -1147,7 +1147,8 @@ static void hub_activate(struct usb_hub *hub, enum
>> hub_activation_type type)
>>                         /* Tell khubd to disconnect the device or
>>                          * check for a new connection
>>                          */
>> -                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION))
>> +                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION)
>> ||
>> +                           (portstatus & USB_PORT_STAT_OVERCURRENT))
>>                                 set_bit(port1, hub->change_bits);
>>
>>                 } else if (portstatus & USB_PORT_STAT_ENABLE) {
>>
>
> I think this could be eligible for backporting. I

I was going to say: It seems to tick the boxes in
Documentation/stable_kernel_rules.txt.

But then gmail thought it would be a good idea to send out the e-mail.

Frans
