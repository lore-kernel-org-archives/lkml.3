Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaLOSNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:13:14 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:44235 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaLOSNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:13:12 -0500
MIME-Version: 1.0
In-Reply-To: <1418396972-32686-1-git-send-email-lyz@rock-chips.com>
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
	<1418396972-32686-1-git-send-email-lyz@rock-chips.com>
Date: Mon, 15 Dec 2014 10:13:11 -0800
X-Google-Sender-Auth: cYap6Acv87yBMLMJS7ghUZRFJR4
Message-ID: <CAD=FV=UuctgCQqhR+NoC4UnX4b7yW0NBDq=s=jimkWugfN4teg@mail.gmail.com>
Subject: Re: [PATCH v7 3/5] usb: dwc2: add generic PHY framework support for
 dwc2 usb controler platform driver.
From: Doug Anderson <dianders@chromium.org>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: paulz <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, jwerner@chromium.org,
        Olof Johansson <olof@lixom.net>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yunzhi,

On Fri, Dec 12, 2014 at 7:09 AM, Yunzhi Li <lyz@rock-chips.com> wrote:
> Get PHY parameters from devicetree and power off usb PHY during
> system suspend.
>
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
>
> ---
>
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3:
> - Fix coding style: both branches of the if() which only one
>   branch of the conditional statement is a single statement
>   should have braces.
> - No need to test dwc2->phy for NULL before calling generic phy
>   APIs.
>
>  drivers/usb/dwc2/gadget.c   | 33 ++++++++++++---------------------
>  drivers/usb/dwc2/platform.c | 36 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 46 insertions(+), 23 deletions(-)

On rk3288-pinky (on a 3.14 tree with backports), I can confirm that
this properly gets us into low power at suspend time.

Tested-by: Doug Anderson <dianders@chromium.org>
