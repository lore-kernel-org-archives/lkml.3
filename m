Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035AbaLLDFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 22:05:31 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:51251 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933928AbaLLDF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 22:05:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WcAJAgj2triu1W4863BT1ew2wf-z6YNHHwiDKpnYmK4w@mail.gmail.com>
References: <1418291722-25448-1-git-send-email-lyz@rock-chips.com>
	<1418291722-25448-2-git-send-email-lyz@rock-chips.com>
	<CAD=FV=WcAJAgj2triu1W4863BT1ew2wf-z6YNHHwiDKpnYmK4w@mail.gmail.com>
Date: Thu, 11 Dec 2014 19:05:27 -0800
X-Google-Sender-Auth: IcfV-vk3qnxK18qCVinakqjhQZ0
Message-ID: <CAD=FV=XrOpZ16k7dNyqzf8m_8Sjq8yn5xCj7+YLiTPU3O2KrrQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
From: Doug Anderson <dianders@chromium.org>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, jwerner@chromium.org,
        Olof Johansson <olof@lixom.net>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yunzhi,

On Thu, Dec 11, 2014 at 10:09 AM, Doug Anderson <dianders@chromium.org> wrote:
>> +               rk_phy->phy = devm_phy_create(dev, NULL, &ops);
>
> This has the wrong number of arguments.  Even before the change that
> added the 4th argument, this is still wrong because "ops" is supposed
> to be the 2nd argument, not the 3rd.
>
> ...so I'm confused how this compiled for you.  I think this ought to be:
>
> rk_phy->phy = devm_phy_create(dev, child, &ops, NULL);
>
> ...but please correct me if I'm mistaken!

As you pointed out privately, I didn't have (dbc9863 phy: remove the
old lookup method).  Sorry about the noise..

Hopefully my other comments are not quite as stupid...

-Doug
