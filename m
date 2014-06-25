Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbaFYPfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:35:44 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16941 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbaFYPfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:35:24 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-3c-53aaec3920c9
Message-id: <53AAEC38.1030506@samsung.com>
Date: Wed, 25 Jun 2014 17:35:20 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Jon Ringle <jon@ringle.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: USB_MUSB_DA8XX with g_multi.ko
References: <CAMwGMjwmdcePeeT5rbZNxCVD7f-bgYgrwBW21hzEV20tkKg9Yg@mail.gmail.com>
In-reply-to: <CAMwGMjwmdcePeeT5rbZNxCVD7f-bgYgrwBW21hzEV20tkKg9Yg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t/xa7qWb1YFGzz5bW5x8H69RfPi9WwW
	5z4fY7G4vGsOm8WiZa3MDqwe++euYfdY9mAys8fxG9uZPD5vkgtgieKySUnNySxLLdK3S+DK
	OPuyhb1gBkfFgravrA2Mx9m6GDk4JARMJH4etOpi5AQyxSQu3FsPFObiEBJYyiixuO8EM4Tz
	Gcg5u4YJpIpXQEvi0rcnLCA2i4CqxK+f05hBbDYBY4m9BzsYQWxRgTCJjlMvmCHqBSV+TL4H
	Vi8icIBRYkOHFIgtLKAt8XbLa7AaIYEAic9L77GB2JwCwRKrj/5gBbGZBcwkHrWsY4aw5SU2
	r3nLPIGRfxaSsbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkiwftnBuPiY
	1SFGAQ5GJR7eAJ5VwUKsiWXFlbmHGCU4mJVEeKOeA4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUw
	Knsu33TqmW3F6sMBndy/Kuym7z8zjd9jJ5dL+Q697VfCWNdMmlmv87/hvrYTz6nAGY8Yp20Q
	1Z33fvaHDz83mOeue1Mc+X3uvdlWYuZPozKUNA61XJh9uqOs+tKWFJZ4yf1KD8tu3Ji2mcOw
	Yflq7dm8oTd0GsOm/G99+sLkyDZDEXEu0eUP7yqxFGckGmoxFxUnAgBR6lVONAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 25.06.2014 17:13, Jon Ringle pisze:
> In commit 787f5627bec80094db487bfcb401e9744f181aed
> usb: musb: make davinci and da8xx glues depend on BROKEN
>
> USB_MUSB_DA8XX was marked as BROKEN
>
> A few months ago, we updated the linux kernel on our AM1808 SoC based
> embedded board from Linux 2.6.33 to the latest long term 3.12.
>
> I am interested in having the USB gadget support on my board, so I
> removed BROKEN on USB_MUSB_DA8XX. I found that when I modprobe
> g_ether, g_serial, and g_mass_storage (by themselves), they all appear
> to work as expected, but if I try to use g_multi to have a composite
> device supporting all three simultaneously, I run into failure during
> initialization.
>

<snip>

>
>>From this I can see that it's failing on the following call in fsg_bind():
> ep = usb_ep_autoconfig(gadget, &fsg_fs_bulk_in_desc);
>

Just a random guess (I don't know your hardware): how many bulk,
iso and interrupt endpoints does your hardware provide? Perhaps you
just run out of endpoints?

AP

