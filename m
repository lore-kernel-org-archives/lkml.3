Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaKRDBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:01:10 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:48790 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaKRDBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:01:08 -0500
MIME-Version: 1.0
In-Reply-To: <1416273684-11300-1-git-send-email-kever.yang@rock-chips.com>
References: <1416273684-11300-1-git-send-email-kever.yang@rock-chips.com>
Date: Mon, 17 Nov 2014 19:01:07 -0800
X-Google-Sender-Auth: Wbo2vN5y_hyJiaFUqDbRmHcKF4Q
Message-ID: <CAD=FV=WNtxxTGtT4h4wg_oX5_c9bGRi+WWViqVXYmSWghn_giw@mail.gmail.com>
Subject: Re: [PATCH v2] usb: dwc2: resume root hub when device detect with
 suspend state
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        wulf <wulf@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jwerner@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Mon, Nov 17, 2014 at 5:21 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> After we implement the bus_suspend/resume, auto suspend id enabled.
> The root hub will be auto suspend if there is no device connected,
> we need to resume the root hub when a device connect detect.
>
> This patch tested on rk3288.
>
> Signed-off-by: Roy Li <roy.li@rock-chips.com>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
> Changes in v2:
> - add definition for hcd structure
> - remove check for bus->root_hub
>
>  drivers/usb/dwc2/hcd_intr.c | 5 +++++
>  1 file changed, 5 insertions(+)

I can confirm that in my tests this fixes the problems introduced by
your v3 patch at <https://patchwork.kernel.org/patch/5266281/>.  On
rk3288-pinky:

Tested-by: Doug Anderson <dianders@chromium.org>
