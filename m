Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaG1EBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 00:01:24 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:35005 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaG1EBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 00:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <53D50601.1020106@rock-chips.com>
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>
	<1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com>
	<20140721085001.GG8843@ulmo>
	<53CD0E82.6030901@rock-chips.com>
	<20140721132723.GH15238@ulmo>
	<53D23192.4000908@rock-chips.com>
	<CAD=FV=XLjYQYmHxp3HBdwVmt6Wa7y-LEnsFKobsgVfFCp2-rRg@mail.gmail.com>
	<53D50601.1020106@rock-chips.com>
Date: Sun, 27 Jul 2014 21:01:20 -0700
X-Google-Sender-Auth: 0HSSV-g78969qovfG1w8kKwXf6Q
Message-ID: <CAD=FV=UvF58NiY76FMi-TPVzsaWRJsR-M5HnHc7MRAWjwjY1jw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
From: Doug Anderson <dianders@chromium.org>
To: caesar <caesar.wang@rock-chips.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caesar,

On Sun, Jul 27, 2014 at 7:00 AM, caesar <caesar.wang@rock-chips.com> wrote:
> /*I think will be show the faill log:->
>
> * rockchip-pwm ff9301a0.pwm: can't request region for resource [mem
> 0xff9301a0-0xff93019f]
> */
>
> pc->base = devm_ioremap_resource(dev, regs);

Did you actually code this up and try it and get this error?  I hadn't
tried it but I researched other dts files and it looked as if there
was one example that was doing this.  ...but perhaps it wasn't
actually doing the ioremap_resource on both ranges.

I'd imagine that this is _probably_ equivalent to what Thierry was
suggesting, so if it didn't work then maybe Thierry's won't work
either?

I don't have any other great suggestions other than doing two memory
ranges for lcdc:

         lcdc@ff930000 {
                 compatible = "rockchip,rk3288-lcdc";
                 reg = <0xff930000 0x1a0>, <0xff9301b0 0xfe50>;
                 ...
         };
         pwm@ff9301a0 {
                 compatible = "rockchip,vop-pwm";
                 reg = <0xff9301a0 0x10>;
                 ...
         };

...but I am certainly nowhere near an expert on this stuff...

-Doug
