Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaKQOZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:25:37 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:43338 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaKQOZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:25:36 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <cc3bea71934be0c22e3d9dccff37cc93>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <546A0554.1080809@rock-chips.com>
Date: Mon, 17 Nov 2014 22:25:24 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>
CC: Doug Anderson <dianders@chromium.org>, Paul Zimmerman <paulz@synopsys.com>,
        Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
References: <Pine.LNX.4.44L0.1411141038530.1043-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1411141038530.1043-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/14/2014 11:55 PM, Alan Stern wrote:
> On Thu, 13 Nov 2014, Julius Werner wrote:
>
>> Another thing might be that the port connect interrupt does not
>> correctly resume the root hub. I don't really know many details about
>> how that works, and it seems pretty complicated. But I can see that
>> all other HCDs seem to call usb_hcd_resume_root_hub() from their
>> interrupt handlers, which we don't. There's also a
> That's how a root hub sends a wakeup request to the kernel.  The
> controller issues an interrupt, and when the HCD's interrupt handler
> sees that the root hub is suspended, it calls usb_hcd_resume_root_hub()
> instead of trying to query the hardware (because in general you _can't_
> query the hardware while it's in a low-power state).
Thanks Alan and Julius, just like what you have mentioned, the dwc2 miss the
usb_hcd_resume_root_hub() when root hub is suspended and device connect
detected.

I have send another patch for that, hope it did the right thing.

- Kever

