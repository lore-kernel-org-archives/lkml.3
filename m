Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbaFYPwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:52:50 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:61776 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbaFYPwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <53AAEC38.1030506@samsung.com>
References: <CAMwGMjwmdcePeeT5rbZNxCVD7f-bgYgrwBW21hzEV20tkKg9Yg@mail.gmail.com>
	<53AAEC38.1030506@samsung.com>
Date: Wed, 25 Jun 2014 11:52:46 -0400
X-Google-Sender-Auth: lixpUTb4BKl80b9jynR0YjqzDAA
Message-ID: <CAMwGMjwAkKidt-B_aenConMbtsk6uSAcfJqXw0r6X2vyADo7Wg@mail.gmail.com>
Subject: Re: USB_MUSB_DA8XX with g_multi.ko
From: Jon Ringle <jon@ringle.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:35 AM, Andrzej Pietrasiewicz
<andrzej.p@samsung.com> wrote:
> W dniu 25.06.2014 17:13, Jon Ringle pisze:
>
>> In commit 787f5627bec80094db487bfcb401e9744f181aed
>> usb: musb: make davinci and da8xx glues depend on BROKEN
>>
>> USB_MUSB_DA8XX was marked as BROKEN
>>
>> A few months ago, we updated the linux kernel on our AM1808 SoC based
>> embedded board from Linux 2.6.33 to the latest long term 3.12.
>>
>> I am interested in having the USB gadget support on my board, so I
>> removed BROKEN on USB_MUSB_DA8XX. I found that when I modprobe
>> g_ether, g_serial, and g_mass_storage (by themselves), they all appear
>> to work as expected, but if I try to use g_multi to have a composite
>> device supporting all three simultaneously, I run into failure during
>> initialization.
>>
>
> <snip>
>
>
>>
>>> From this I can see that it's failing on the following call in
>>> fsg_bind():
>>
>> ep = usb_ep_autoconfig(gadget, &fsg_fs_bulk_in_desc);
>>
>
> Just a random guess (I don't know your hardware): how many bulk,
> iso and interrupt endpoints does your hardware provide? Perhaps you
> just run out of endpoints?

Perhaps... From the documentation it appears that I can have 4
simultaneous RX/TX endpoints... Is this not enough?

34.1.2 Features
The USB has the following features:
• Operating as a host, it complies with the USB 2.0 standard for
high-speed (480 Mbps), full-speed
(12 Mbps), and low-speed (1.5 Mbps) operations with a peripheral
• Operating as a peripheral, it complies with the USB 2.0 standard for
high-speed (480 Mbps) and
full-speed (12 Mbps) operation with a host.
• Supports USB extensions for Session Request (SRP) and Host
Negotiation (HNP) – OTG
• Supports 4 simultaneous RX and TX endpoints, in addition to control
endpoint, more devices can be
supported by dynamically switching endpoints states
• Each endpoint (other than endpoint 0) can support all transfer types
(control, bulk, interrupt, and
isochronous)
• Includes a 4K endpoint FIFO RAM, and supports programmable FIFO sizes
• External 5V power supply for VBUS, when operating as host, enabled
directly by the USB controller
through a dedicated signal
• Includes a DMA controller that supports 4 TX and 4 RX DMA channels
• Includes four types of Communications Port Programming Interface
(CPPI) 4.1 DMA compliant transfer
modes, Transparent, Generic RNDIS, RNDIS, and Linux CDC mode of DMA
for accelerating RNDIS
type protocols using short packet termination over USB.
• DMA supports single data transfer size up to 4Mbytes
