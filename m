Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaKMAkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:40:52 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34809 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaKMAkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:40:51 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Doug Anderson <dianders@chromium.org>,
        "Dmitry Torokhov" <dtor@chromium.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAD=FV=UsYWDw0wB6KSANXZYnnBFdTL9wOEqf9DoUF8aFuDpNSw@mail.gmail.com>
Cc: "Heiko Stuebner" <heiko@sntech.de>, "Jianqun" <jay.xu@rock-chips.com>,
        "Kever Yang" <kever.yang@rock-chips.com>,
        "Mark yao" <mark.yao@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20141112213845.GA14153@dtor-ws>
 <CAD=FV=UsYWDw0wB6KSANXZYnnBFdTL9wOEqf9DoUF8aFuDpNSw@mail.gmail.com>
Message-ID: <20141113004046.25314.61598@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: rockchip: ensure HCLK_VIO2_H2P and PCLK_VIO2_H2P stay
 enabled
Date: Wed, 12 Nov 2014 16:40:46 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Doug Anderson (2014-11-12 13:49:18)
> Hi,
> 
> On Wed, Nov 12, 2014 at 1:38 PM, Dmitry Torokhov <dtor@chromium.org> wrote:
> > Currently there is no driver owning these clocks and they have to stay
> > up for the system to function properly, so let's mark them as
> > CLK_IGNORE_UNUSED.
> >
> > Without this patch we have trouble with suspend/resume and we have
> > trouble turning the eDP back on if it ever idles off.
> >
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> > ---
> >  drivers/clk/rockchip/clk-rk3288.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> I'm already on the signed-off-by (mostly because I tweaked the commit
> message and tested this), but in case anyone cares I have reviewed
> this and tested it.  ;)
> 
> ...obviously we want to get to the bottom of the right way to handle
> all of these clocks, but since we _just_ removed the blanket "leave
> all clocks enabled" adding a few clocks back into the fold seems sane
> until we get all our ducks in a row.
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>

Seems fine to me. Just to be clear, Heiko will be picking up the
Rockchip clock patches and submitting a PR, correct? I believe last
merge window was the first time we did that for Rockchip and it went
well.

Regards,
Mike
