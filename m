Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaKJS0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:26:20 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:56828 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaKJS0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:26:18 -0500
MIME-Version: 1.0
In-Reply-To: <5460B45A.3090503@rock-chips.com>
References: <1415237402-24665-1-git-send-email-kever.yang@rock-chips.com>
	<CAODwPW_Udap8oYGhKSLWhpiLLhsOUKNsMbpxC7CLEz-Cg53JQw@mail.gmail.com>
	<5460B45A.3090503@rock-chips.com>
Date: Mon, 10 Nov 2014 10:26:17 -0800
X-Google-Sender-Auth: 8GAmL8YCgpCYg9qP4fKxBo0H8-4
Message-ID: <CAODwPW9HUaHuDjCEo9E=EUtnWPaK28q06L4kFYFyXUusNZngFw@mail.gmail.com>
Subject: Re: [PATCH v2] usb: dwc2: add bus suspend/resume for dwc2
From: Julius Werner <jwerner@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Julius Werner <jwerner@chromium.org>, Tao Huang <huangtao@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyW?= <dkl@rock-chips.com>,
        addy ke <addy.ke@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org, Jianqun Xu <xjq@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>, romain.perier@gmail.com,
        Sonny Rao <sonnyrao@chromium.org>, Paul Zimmerman <paulz@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The contract for bus_suspend() is that it will suspend all ports not
>> yet suspended, keep track of those ports and then only resume those in
>> bus_resume() (compare, for example, how XHCI keeps track of that with
>> xhci_bus_state.bus_suspended in xhci_bus_suspend/resume()). So you
>> need something here to remember whether this function suspended the
>> port or whether it had already been suspended, and then only resume
>> the port in bus_resume() in the former case.
>
> In fact, the dwc2 controller only support one port, so the hprt0
> is the only one port we need to care.

Yes, I know, but that one port still needs to play by the rules the
USB core expects. All I'm saying is: if the port was already suspended
during bus_suspend(), then the next bus_resume() should not resume it.

The rest looks good to me now. But in order to get it really working,
I think we'll still need the actual driver.pm suspend/resume methods,
at least for the HCD_FLAG_HW_ACCESSIBLE and the
usb_root_hub_lost_power() handling (probably better in a separate
patch).
