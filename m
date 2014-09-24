Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaIXUV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:21:59 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54935 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIXUV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:21:58 -0400
MIME-Version: 1.0
In-Reply-To: <1566610.B4NH8lpaoI@diego>
References: <1566610.B4NH8lpaoI@diego>
Date: Wed, 24 Sep 2014 13:21:57 -0700
X-Google-Sender-Auth: u3yCafRvDQNSWLIKSW37fVJo0tw
Message-ID: <CAD=FV=V5ZBAVEV=-BK7MEWO2KLUqQ4L6ZXrxkGA=AsKxY3mq9w@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: add initcall to set clk defaults after
 syscons are available
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 7, 2014 at 5:57 AM, Heiko Stübner <heiko@sntech.de> wrote:
> PLLs on Rockchip platforms report their locking state in an external
> register situated in the "General Register Files" which is provided
> through a syscon device.
>
> When the initial clk init runs, this syscon is of course not yet
> available, making it impossible to set PLLs to other frequencies
> through the assigned-rate property of the clock-controller node.
>
> Syscon devices are initialized through a postcore initcall, so add an
> arch_initcall to rerun the rockchip specific clock initalization when
> the GRF is available.
>
> As the clock init already runs two times (through of_clk_add_provider
> and of_clk_init), a third time shouldn't hurt to much and in the best
> case wouldn't change any settings at all.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  drivers/clk/rockchip/clk.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

My current understanding is that this patch is on hold pending
<https://patchwork.kernel.org/patch/4945531/> (AKA mfd: syscon:
Decouple syscon interface from platform devices).  If that patch lands
then we can drop this one.

-Doug
