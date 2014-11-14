Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbaKNURX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:17:23 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:50345 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaKNURV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:17:21 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Julius Werner <jwerner@chromium.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Doug Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "Dinh Nguyen" <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
Thread-Topic: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
Thread-Index: AQHP/OemHIpdmIh/Rku4z/uYLWGLo5xeK1WAgAAWRACAAdeFAIAAeWgg
Date: Fri, 14 Nov 2014 20:17:16 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844EBC6A@US01WEMBX2.internal.synopsys.com>
References: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com>
	<CAD=FV=V-D3qTtnwjme8k=boUkoGGPmfvcF=Jboq0qcRBzKrY6g@mail.gmail.com>
	<5463FE5E.906@rock-chips.com>
 <CAODwPW9Avc1RCdDoarGg2cZirn7ivu4JEdUTV485J=nLLmecTQ@mail.gmail.com>
In-Reply-To: <CAODwPW9Avc1RCdDoarGg2cZirn7ivu4JEdUTV485J=nLLmecTQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAEKHUem003473

> From: jwerner@google.com [mailto:jwerner@google.com] On Behalf Of Julius Werner
> Sent: Thursday, November 13, 2014 8:50 PM
> 
> > I will figure out how to make dwc2 detect the device connect after auto
> > suspend,
> > or disable the auto suspend feature for the dwc2 hcd.
> 
> I think auto-suspend of the root hub device (which is what calls
> bus_suspend, but is not the host controller device itself) is expected
> to always happen and not really meant to be disabled. I'm surprised
> that the controller would fail to come back up, though. Does removing
> the PCGCTL part make it work? That's the only thing I can think of
> (but then again the function should immediately return if the port is
> not in L0, so if there is nothing plugged in the suspend shouldn't
> really do anything).

Hi guys,

I don't have any experience with suspend/resume on the dwc2 controller
I'm afraid. One suggestion would be to look at our Synopsys vendor
driver to see how it is handled there.

That driver is part of the Raspberry Pi upstream kernel, which you
can find at https://github.com/raspberrypi/linux. The driver is
under drivers/usb/host/dwc_otg.

In particular, in dwc_otg_cil_intr.c there is a function named
dwc_otg_handle_wakeup_detected_intr() which might be of interest.
Unfortunately, that driver code is rather convoluted, so it may be
difficult to figure out exactly what the driver is doing.

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
