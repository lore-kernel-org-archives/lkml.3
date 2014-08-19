Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaHSS4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:56:41 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:51677 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaHSS4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <1407286910-30906-3-git-send-email-kever.yang@rock-chips.com>
References: <1407286910-30906-1-git-send-email-kever.yang@rock-chips.com>
	<1407286910-30906-3-git-send-email-kever.yang@rock-chips.com>
Date: Tue, 19 Aug 2014 11:56:37 -0700
X-Google-Sender-Auth: 2QjWZc50Nzvl3Gm3zUx4j2sEq2o
Message-ID: <CAD=FV=UNeuGfSCS4zbWb6Pjt+n5-aDz7yrt8E2bCR8eFoYVcCg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] usb: dwc2: add 'mode' which based on Kconfig
 select or dts setting
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Zimmerman <paulz@synopsys.com>, Heiko Stuebner <heiko@sntech.de>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, wulf <wulf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, Jingoo Han <jg1.han@samsung.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Tue, Aug 5, 2014 at 6:01 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> According to the "dr_mode", the otg controller can work as
> device role and host role. Some boards always want to use host mode
> and some other boards want to use gadget mode. We use the dts setting
> to set dwc2's mode, rather than fixing it to whatever hardware says.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>
> Changes in v4:
> - From Doug's suggestion:
>  -- remove dr_mode init from Kconfig code
>  -- change the commit meesage
>
> Changes in v3:
> - fix the odd spacing in dwc2_hsotg struct
> - From Jingoo's suggestion:
>     change the commit message
> - add dr_mode init from Kconfig
>
> Changes in v2:
> - put spaces around '+' operator
> - expand the comment for dr_mode
> - handle dr_mode is USB_DR_MODE_OTG
>
>  drivers/usb/dwc2/core.c     | 18 ++++++++++++++++++
>  drivers/usb/dwc2/core.h     |  5 +++++
>  drivers/usb/dwc2/platform.c |  4 ++++
>  3 files changed, 27 insertions(+)

In case it's useful, I've actually tested myself that this is
necessary and sufficient to get the OTG port to behave properly as a
host port on an rk3288 board.

Tested-by: Doug Anderson <dianders@chromium.org>


Greg: now that the merge window has closed, are you interested in
landing Kever's changes (with Paul's Ack).  There's this series and
another adding rk3288 support.  If you'd like Kever to repost with
Acks or want pointers to patches, please yell!  ;)

-Doug
