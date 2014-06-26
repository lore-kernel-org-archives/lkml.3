Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbaFZCqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:46:04 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:54324 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaFZCqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:46:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAMwGMjwAkKidt-B_aenConMbtsk6uSAcfJqXw0r6X2vyADo7Wg@mail.gmail.com>
References: <CAMwGMjwmdcePeeT5rbZNxCVD7f-bgYgrwBW21hzEV20tkKg9Yg@mail.gmail.com>
	<53AAEC38.1030506@samsung.com>
	<CAMwGMjwAkKidt-B_aenConMbtsk6uSAcfJqXw0r6X2vyADo7Wg@mail.gmail.com>
Date: Wed, 25 Jun 2014 22:46:00 -0400
X-Google-Sender-Auth: E-Om2T0E-gqJztRd0PL_t8jowiM
Message-ID: <CAMwGMjw6gxKSJ1dH=jx0htV9r=HDtYwqbx3OyZz2gWbt_f-4sQ@mail.gmail.com>
Subject: Re: USB_MUSB_DA8XX with g_multi.ko
From: Jon Ringle <jon@ringle.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:52 AM, Jon Ringle <jon@ringle.org> wrote:
> On Wed, Jun 25, 2014 at 11:35 AM, Andrzej Pietrasiewicz
> <andrzej.p@samsung.com> wrote:
>> W dniu 25.06.2014 17:13, Jon Ringle pisze:
>>
>>> In commit 787f5627bec80094db487bfcb401e9744f181aed
>>> usb: musb: make davinci and da8xx glues depend on BROKEN
>>>
>>> USB_MUSB_DA8XX was marked as BROKEN
>>>
>>> A few months ago, we updated the linux kernel on our AM1808 SoC based
>>> embedded board from Linux 2.6.33 to the latest long term 3.12.
>>>
>>> I am interested in having the USB gadget support on my board, so I
>>> removed BROKEN on USB_MUSB_DA8XX. I found that when I modprobe
>>> g_ether, g_serial, and g_mass_storage (by themselves), they all appear
>>> to work as expected, but if I try to use g_multi to have a composite
>>> device supporting all three simultaneously, I run into failure during
>>> initialization.
>>>
>>
>> <snip>
>>
>>
>>>
>>>> From this I can see that it's failing on the following call in
>>>> fsg_bind():
>>>
>>> ep = usb_ep_autoconfig(gadget, &fsg_fs_bulk_in_desc);
>>>
>>
>> Just a random guess (I don't know your hardware): how many bulk,
>> iso and interrupt endpoints does your hardware provide? Perhaps you
>> just run out of endpoints?
>
> Perhaps... From the documentation it appears that I can have 4
> simultaneous RX/TX endpoints... Is this not enough?

I now see that each function seems to require 2 endpoints, so with 4
endpoints available, I can only have two functions with this hardware.
I tested this successfully with g_adm_ms.ko having both serial and
mass storage working. The only thing I needed to do was to remove the
BROKEN dependency on USB_MUSB_DA8XX. Is there anything else I would
have to do besides just removing BROKEN to get this accepted back into
the kernel source tree?

Jon
