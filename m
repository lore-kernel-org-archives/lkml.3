Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaB0CCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:02:31 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35209 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaB0CCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:02:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Masanari Iida" <standby24x7@gmail.com>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <52FF9EFC.2060707@overkiz.com>
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org
References: <1392124507-14463-1-git-send-email-standby24x7@gmail.com>
 <52FA2338.3030707@overkiz.com> <52FF9EFC.2060707@overkiz.com>
Message-ID: <20140227020226.12081.28850@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk:at91: Fix memory leak in of_at91_clk_master_setup()
Date: Wed, 26 Feb 2014 18:02:26 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2014-02-15 09:08:12)
> Hi Mike,
> 
> Could you take this patch for the next 3.14 release ?

Taken in for the next batch of fixes.

Regards,
Mike

> 
> Best Regards,
> 
> Boris
> 
> On 11/02/2014 14:18, Boris BREZILLON wrote:
> > On 11/02/2014 14:15, Masanari Iida wrote:
> >> cppcheck detected following error
> >> [clk-master.c:245]: (error) Memory leak: characteristics
> >>
> >> The original code forgot to free characteristics when
> >> irq_of_parse_and_map() failed.
> >>
> >> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> > Acked-by Boris BREZILLON <b.brezillon@overkiz.com>
> >
> > Thanks for fixing this.
> >
> > Best Regards,
> >
> > Boris
> >> ---
> >>   drivers/clk/at91/clk-master.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/clk/at91/clk-master.c 
> >> b/drivers/clk/at91/clk-master.c
> >> index bd313f7..c1af80b 100644
> >> --- a/drivers/clk/at91/clk-master.c
> >> +++ b/drivers/clk/at91/clk-master.c
> >> @@ -242,7 +242,7 @@ of_at91_clk_master_setup(struct device_node *np, 
> >> struct at91_pmc *pmc,
> >>         irq = irq_of_parse_and_map(np, 0);
> >>       if (!irq)
> >> -        return;
> >> +        goto out_free_characteristics;
> >>         clk = at91_clk_register_master(pmc, irq, name, num_parents,
> >>                          parent_names, layout,
> >
> 
