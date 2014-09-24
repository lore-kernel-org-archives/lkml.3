Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaIXU11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:27:27 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42401 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaIXU10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:27:26 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: rockchip: add initcall to set clk defaults after syscons are available
Date: Wed, 24 Sep 2014 22:27:17 +0200
Message-ID: <1913186.v9VZxj5m8a@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAD=FV=V5ZBAVEV=-BK7MEWO2KLUqQ4L6ZXrxkGA=AsKxY3mq9w@mail.gmail.com>
References: <1566610.B4NH8lpaoI@diego> <CAD=FV=V5ZBAVEV=-BK7MEWO2KLUqQ4L6ZXrxkGA=AsKxY3mq9w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. September 2014, 13:21:57 schrieb Doug Anderson:
> Hi,
> 
> On Thu, Aug 7, 2014 at 5:57 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > PLLs on Rockchip platforms report their locking state in an external
> > register situated in the "General Register Files" which is provided
> > through a syscon device.
> > 
> > When the initial clk init runs, this syscon is of course not yet
> > available, making it impossible to set PLLs to other frequencies
> > through the assigned-rate property of the clock-controller node.
> > 
> > Syscon devices are initialized through a postcore initcall, so add an
> > arch_initcall to rerun the rockchip specific clock initalization when
> > the GRF is available.
> > 
> > As the clock init already runs two times (through of_clk_add_provider
> > and of_clk_init), a third time shouldn't hurt to much and in the best
> > case wouldn't change any settings at all.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> > 
> >  drivers/clk/rockchip/clk.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> 
> My current understanding is that this patch is on hold pending
> <https://patchwork.kernel.org/patch/4945531/> (AKA mfd: syscon:
> Decouple syscon interface from platform devices).  If that patch lands
> then we can drop this one.

correct.

I've tested v5 this evening and apart from the debugfs issue I reported there, 
the whole assigned-clocks init worked really nice.


Heiko
