Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaGBKUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:20:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58702 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaGBKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:20:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-ed-53b3dccc2f10
Content-transfer-encoding: 8BIT
Message-id: <1404296397.12439.2.camel@AMDC1943>
Subject: Re: [PATCH v5 05/14] clk: Add generic driver for Maxim PMIC clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mike Turquette <mturquette@linaro.org>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 02 Jul 2014 12:19:57 +0200
In-reply-to: <53B3DB49.6020604@collabora.co.uk>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403806546-31122-6-git-send-email-javier.martinez@collabora.co.uk>
 <CAKew6eU5X=WxhECtwUUwbXe_fCRU4bD6B7caWiA2dwcBfThd-g@mail.gmail.com>
 <20140701172616.32686.44374@quantum> <53B3DB49.6020604@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xK7pn72wONpizktFiycWr7BZTHz5h
	s9jUv5XdYv6Rc6wWZ5cdZLM4+rvAonfBVTaL+1+PMlp8u9LBZLHp8TVWi8u75rBZzDi/j8ni
	6YSLbBanrn9mszjdzWox/fhbVou+tZfYLOb+bmR1EPKY3XCRxePv8+ssHjvuLmH02DnrLrvH
	plWdbB53ru1h85h3MtBj85J6jysnmlg9+rasYvSYPu8nk8fnTXIBPFFcNimpOZllqUX6dglc
	GZfPXmYteChX8eXOJfYGxjniXYycHBICJhJHJ6xkhLDFJC7cW8/WxcjFISSwlFGi6/weJpAE
	r4CgxI/J91i6GDk4mAXkJY5cygYJMwuoS0yat4gZxBYS+MwoMeGRJUS5vsTOOd/AZgoLeEvM
	6l7ODmKzCRhLbF6+hA3EFhGwk7ix+iEzyC5mgfesEu8PHQFrYBFQlZj2YC7YUE6gQfPudUEd
	tIxJ4sLrE0wQlypLzNt/jGkCo8AsJPfNQrhvFpL7FjAyr2IUTS1NLihOSs811CtOzC0uzUvX
	S87P3cQIicgvOxgXH7M6xCjAwajEw9u4YkOwEGtiWXFl7iFGCQ5mJRHe/hubg4V4UxIrq1KL
	8uOLSnNSiw8xMnFwSjUwqvh7/QwweF0w9dbqlW9ncc49qSLnW5oTfLnWZfqEDcVzjqpIb/Dl
	uFxtyvvr3LV5MXKLnvFX+K3ztTg97W37uo+PP67T2vliaks5V2zQbKOnz8xf/FM54+LTeE7j
	yNnq7dnGRfWWTgpt9eypK8q+zLm8v68lx+ei/nK7T0esXSJm2D3Udma2VGIpzkg01GIuKk4E
	AFw5RS2mAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-07-02 at 12:13 +0200, Javier Martinez Canillas wrote:
> Hello Mike,
> 
> On 07/01/2014 07:26 PM, Mike Turquette wrote:
> > Quoting Yadwinder Singh Brar (2014-06-29 21:01:36)
> >> Hi Javier,
> >> 
> >> On Thu, Jun 26, 2014 at 11:45 PM, Javier Martinez Canillas
> >> <javier.martinez@collabora.co.uk> wrote:
> >> > Maxim Integrated Power Management ICs are very similar with
> >> > regard to their clock outputs. Most of the clock drivers for
> >> > these chips are duplicating code and are simpler enough that
> >> > can be converted to use a generic driver to consolidate code
> >> > and avoid duplication.
> >> >
> >> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> >> > Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >> > ---
> >> >
> >> > Changes since v4:
> >> >  - Return recalc 0 if clock isn't enabled in Suggested by Yadwinder Singh Brar.
> >> >
> >> 
> >> It seems you didn't implement or posted same patch again :) .
> >> 
> >> > Changes since v3:
> >> >  - Add current copyright information. Suggested by Krzysztof Kozlowski
> >> >  - Do a single allocation for struct max_gen_clk. Suggested by Krzysztof Kozlowski
> >> >  - Add EXPORT_SYMBOL() for exported symbols. Suggested by Krzysztof Kozlowski
> >> >
> >> >  drivers/clk/Kconfig       |   3 +
> >> >  drivers/clk/Makefile      |   1 +
> >> >  drivers/clk/clk-max-gen.c | 195 ++++++++++++++++++++++++++++++++++++++++++++++
> >> >  drivers/clk/clk-max-gen.h |  32 ++++++++
> >> >  4 files changed, 231 insertions(+)
> >> >  create mode 100644 drivers/clk/clk-max-gen.c
> >> >  create mode 100644 drivers/clk/clk-max-gen.h
> >> >
> >> 
> >> [ .. ]
> >> 
> >> > +
> >> > +static unsigned long max_gen_recalc_rate(struct clk_hw *hw,
> >> > +                                        unsigned long parent_rate)
> >> > +{
> >> > +       return 32768;
> >> > +}
> >> 
> >> Its still same here.
> > 
> > Changing this would be a new behavior. I do not know of any other clock
> > drivers that conditionally returns a rate of 0 based on whether or not
> > the clock is gated.
> > 
> 
> After Yadwinder feedback I searched for clock drivers that returned 0 when the
> clock was not enabled/prepared and found for example drivers/clk/clk-s2mps11.c:
> 
> 
> static unsigned long s2mps11_clk_recalc_rate(struct clk_hw *hw,
>                                              unsigned long parent_rate)
> {
>         struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
>         if (s2mps11->enabled)
>                 return 32768;
>         else
>                 return 0;
> }
> 
> > It is also buggy since calls to clk_enable and clk_disable do not invoke
> > .recalc_rate, so the rate of your clock would not be updated from the
> > framework's perspective until some later point where you call
> > clk_set_rate or something.
> >
> 
> s2ps11->enabled is set in the driver's clk_ops .prepare and .unprepare function
> handlers and calls to clk_prepare and clk_unprepare also don't seems to invoke
> .recalc_rate so I guess that driver is wrong as well and should just return the
> clock rate unconditionally?

The s2mps11 may be not a best example for proper clock driver :).
Karol Wrona already sent a patch for s2mps11:
https://lkml.org/lkml/2014/7/1/389


Best regards,
Krzysztof

> 
> > If your driver needs to know whether or not the clock is enabled then we
> > could introduce a new bool clk_is_enabled(struct clk *clk); to clk.h,
> > but I'd rather not do that. Instead if a driver needs a clock then it
> > calls clk_enable on it without any knowledge about the internal state of
> > the clock enable_count.
> > 
> > Regards,
> > Mike
> >
> 
> Thanks a lot for the explanation, I'll revert that change then and return the
> clock rate unconditionally on the next version of the patch-set.
> 
> Best regards,
> Javier

