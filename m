Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbbAFBXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:23:37 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:45402 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbbAFBXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:23:34 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Kever Yang <kever.yang@rock-chips.com>,
        Doug Anderson <dianders@chromium.org>
CC: Felipe Balbi <balbi@ti.com>, Dinh Nguyen <dinguyen@opensource.altera.com>,
        "romain.perier@gmail.com" <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jwerner@chromium.org" <jwerner@chromium.org>
Subject: RE: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
Thread-Topic: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
Thread-Index: AQHP/OemHIpdmIh/Rku4z/uYLWGLo5xeK1WAgAAWRACAVGDcIA==
Date: Tue, 6 Jan 2015 01:23:30 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304845059B3@US01WEMBX2.internal.synopsys.com>
References: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com>
 <CAD=FV=V-D3qTtnwjme8k=boUkoGGPmfvcF=Jboq0qcRBzKrY6g@mail.gmail.com>
 <5463FE5E.906@rock-chips.com>
In-Reply-To: <5463FE5E.906@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.20]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t061NfN6009875

> From: Kever Yang [mailto:kever.yang@rock-chips.com]
> Sent: Wednesday, November 12, 2014 4:42 PM
> 
> On 11/13/2014 07:22 AM, Doug Anderson wrote:
> > Kever,
> >
> > On Mon, Nov 10, 2014 at 5:09 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> >> Hcd controller needs bus_suspend/resume, dwc2 controller make
> >> root hub generate suspend/resume signal with hprt0 register
> >> when work in host mode.
> >> After the root hub enter suspend, we can make controller enter
> >> low power state with PCGCTL register.
> >>
> >> We also update the lx_state for hsotg state.
> >>
> >> This patch has tested on rk3288 with suspend/resume.
> >>
> >> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> >> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> >> ---
> >>
> >> Changes in v3:
> >> - remove CONFIG_PM macro for bus_suspend/resume
> >> - add PCGCTL operation for no device connect case
> >>
> >> Changes in v2:
> >> - update commit message
> >> - make dwc2 suspend/resume sourcecode work
> >>
> >>   drivers/usb/dwc2/hcd.c | 88 +++++++++++++++++++++++++++++++++++++++++++-------
> >>   1 file changed, 77 insertions(+), 11 deletions(-)
> > I would certainly appreciate confirmation, but my inclination is to
> > NAK this change due to the fact that it regresses functionality.  I
> > haven't done any serious review of it, but I've been testing it and it
> > appears to break hotplug.
> >
> > Said another way, I did this:
> >
> > 1. Without this patch, I booted with a USB stick in.  It was detected.
> > I unplugged it, waited 5 seconds, and then plugged it back in.  The
> > USB stick was redetcted.
> >
> > 2. With this patch, I did the same thing.  The USB not redected after
> > plugging it back in.
> With this patch, the dwc2 hcd/root hub will be auto suspend after device
> on port is disconnected, and it can't detect the device connect any more,
> I think that's the problem.
> 
> I will figure out how to make dwc2 detect the device connect after auto
> suspend,
> or disable the auto suspend feature for the dwc2 hcd.

Kever,

This patch has made it into Linus' kernel as commit 0cf884e819e0, and
it breaks disconnect/connect on at least the Altera SOCFPGA platform.
I haven't been able to test it on any other platforms.

You need to submit a patch to either fix this, or to only enable this
feature for the Rock-chip platform. Otherwise the patch has to be
reverted.

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
