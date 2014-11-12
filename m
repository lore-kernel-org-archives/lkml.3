Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaKLXW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:22:28 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:35870 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaKLXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:22:26 -0500
MIME-Version: 1.0
In-Reply-To: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com>
References: <1415624983-22413-1-git-send-email-kever.yang@rock-chips.com>
Date: Wed, 12 Nov 2014 15:22:25 -0800
X-Google-Sender-Auth: H-56rMnr_zauOYHqsVWVlH4rV0E
Message-ID: <CAD=FV=V-D3qTtnwjme8k=boUkoGGPmfvcF=Jboq0qcRBzKrY6g@mail.gmail.com>
Subject: Re: [PATCH v3] usb: dwc2: add bus suspend/resume for dwc2
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>, romain.perier@gmail.com,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jwerner@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Mon, Nov 10, 2014 at 5:09 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> Hcd controller needs bus_suspend/resume, dwc2 controller make
> root hub generate suspend/resume signal with hprt0 register
> when work in host mode.
> After the root hub enter suspend, we can make controller enter
> low power state with PCGCTL register.
>
> We also update the lx_state for hsotg state.
>
> This patch has tested on rk3288 with suspend/resume.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>
> Changes in v3:
> - remove CONFIG_PM macro for bus_suspend/resume
> - add PCGCTL operation for no device connect case
>
> Changes in v2:
> - update commit message
> - make dwc2 suspend/resume sourcecode work
>
>  drivers/usb/dwc2/hcd.c | 88 +++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 77 insertions(+), 11 deletions(-)

I would certainly appreciate confirmation, but my inclination is to
NAK this change due to the fact that it regresses functionality.  I
haven't done any serious review of it, but I've been testing it and it
appears to break hotplug.

Said another way, I did this:

1. Without this patch, I booted with a USB stick in.  It was detected.
I unplugged it, waited 5 seconds, and then plugged it back in.  The
USB stick was redetcted.

2. With this patch, I did the same thing.  The USB not redected after
plugging it back in.

-Doug
