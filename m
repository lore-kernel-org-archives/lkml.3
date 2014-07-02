Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbaGBGlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:41:12 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37812 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaGBGlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:41:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        "Boris BREZILLON" <boris.brezillon@free-electrons.com>,
        "Himangi Saraogi" <himangi774@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53AF35D2.4090904@elopez.com.ar>
Cc: "Maxime Ripard" <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        julia.lawall@lip6.fr
References: <20140628172355.GA3387@himangi-Dell> <53AF024B.3010100@free-electrons.com>
 <53AF35D2.4090904@elopez.com.ar>
Message-ID: <20140702064056.23338.13139@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: sunxi: fix devm_ioremap_resource error detection code
Date: Tue, 01 Jul 2014 23:40:56 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Emilio López (2014-06-28 14:38:26)
> Hi,
> 
> El 28/06/14 14:58, Boris BREZILLON escribió:
> > Hello,
> >
> > On 28/06/2014 19:23, Himangi Saraogi wrote:
> >> devm_ioremap_resource returns an ERR_PTR value, not NULL, on failure.
> >>
> >> A simplified version of the semantic match that finds this problem is as
> >> follows:
> >>
> >> // <smpl>
> >> @@
> >> expression e,e1;
> >> statement S;
> >> @@
> >>
> >> *e = devm_ioremap_resource(...);
> >> if (!e1) S
> >>
> >> // </smpl>
> >> Signed-off-by: Himangi Saraogi<himangi774@gmail.com>
> >> Acked-by: Julia Lawall<julia.lawall@lip6.fr>
> >> ---
> >>   drivers/clk/sunxi/clk-sun6i-apb0-gates.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
> >> index 44cd27c..670f90d 100644
> >> --- a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
> >> +++ b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
> >> @@ -29,7 +29,7 @@ static int sun6i_a31_apb0_gates_clk_probe(struct platform_device *pdev)
> >>
> >>      r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>      reg = devm_ioremap_resource(&pdev->dev, r);
> >> -    if (!reg)
> >> +    if (IS_ERR(reg))
> >>              return PTR_ERR(reg);
> >>
> >>      clk_parent = of_clk_get_parent_name(np, 0);
> >
> > Oops, one more mistake in testing devm_ioremap_resource return code (I
> > always mix devm_ioremap_resource and devm_request_and_ioremap behaviours).
> >
> > Sorry for the inconvenience, and of course, you have my:
> >
> > Acked-by Boris BREZILLON <boris.brezillon@free-electrons.com>
> 
> Mike, do you want to take this directly for the -rc cycle, or should I 
> queue it for 3.17? Please let me know.

I've picked it for the current -rc cycle.

Thanks,
Mike

> 
> Cheers,
> 
> Emilio
