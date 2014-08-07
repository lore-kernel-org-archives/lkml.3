Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaHGVBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:01:14 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:54786 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaHGVBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:01:10 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Doug Anderson <dianders@chromium.org>
CC: Kever Yang <kever.yang@rock-chips.com>,
        "heiko@sntech.de" <heiko@sntech.de>, "olof@lixom.net" <olof@lixom.net>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 2/4] usb: dwc2: add compatible data for rockchip soc
Thread-Topic: [PATCH v4 2/4] usb: dwc2: add compatible data for rockchip soc
Thread-Index: AQHPsiLtn9dZ0AQL7EiI6xLR7fBZd5vFdFmAgACfv4D//4t0sA==
Date: Thu, 7 Aug 2014 20:59:43 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C4F22@US01WEMBX2.internal.synopsys.com>
References: <1407404095-3265-1-git-send-email-kever.yang@rock-chips.com>
	<1407404095-3265-3-git-send-email-kever.yang@rock-chips.com>
	<A2CA0424C0A6F04399FB9E1CD98E0304844C4DF6@US01WEMBX2.internal.synopsys.com>
 <CAD=FV=UqeDWQiA7sAS6CuM74B0GS+5HcJD9Bd8FfF7awsdG7Vg@mail.gmail.com>
In-Reply-To: <CAD=FV=UqeDWQiA7sAS6CuM74B0GS+5HcJD9Bd8FfF7awsdG7Vg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s77L1IWF020331

> From: dianders@google.com [mailto:dianders@google.com] On Behalf Of Doug Anderson
> Sent: Thursday, August 07, 2014 1:53 PM
> 
> On Thu, Aug 7, 2014 at 11:26 AM, Paul Zimmerman
> <Paul.Zimmerman@synopsys.com> wrote:
> >> From: Kever Yang [mailto:kever.yang@gmail.com] On Behalf Of Kever Yang
> >> Sent: Thursday, August 07, 2014 2:35 AM
> >>
> >> This patch add compatible data for dwc2 controller found on
> >> rk3066, rk3188 and rk3288 processors from rockchip.
> >>
> >> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> >> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> >> ---
> >>
> >> Changes in v4:
> >> - max_transfer_size change to 65536, this should be enough
> >>   for most transfer, the hardware auto-detect will set this
> >>   to 0x7ffff which may make dma_alloc_coherent fail when
> >>   non-dword aligned buf from driver like usbnet happen.
> >
> > Hi Kever,
> >
> > Did you test this change thoroughly? I have vague memories of any
> > value above 65535 causing problems, at least on my hardware. And I
> > see it is set to 65535 in both pci.c and platform.c. I could be
> > wrong, but I thought I should mention it.
> 
> Certainly it is documented in the header file to have a max of 65535:
> 
>  * @max_transfer_size:  The maximum transfer size supported, in bytes
>  *                       2047 to 65,535
>  *                      Actual maximum value is autodetected and also
>  *                      the default.
> 
> ...but looking at the register definition that I see, the size can be
> up to 19 bits.  A 19-bit transfer far exceeds 65535.  Do you remember
> what the error was?  Certainly I can imagine there being errors with
> large calls to dma_alloc_coherent()...

It's pretty fuzzy. I think a certain type of transfer (Isoc?) didn't
work. But I may be misremembering, the problem could have been with
max_packet_count > 255 instead. If you have tested it thoroughly with
different types of devices then it's probably OK.

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
