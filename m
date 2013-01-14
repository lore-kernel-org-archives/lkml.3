Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3ANXfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:35:03 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34570 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3ANXfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:35:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Rob Herring <robherring2@gmail.com>,
        Denis Efremov <yefremov.denis@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <50E99120.7080608@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
References: <1357482103-14116-1-git-send-email-yefremov.denis@gmail.com>
 <50E99120.7080608@gmail.com>
Message-ID: <20130114233455.23734.83658@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: remove exported function from __init section
Date: Mon, 14 Jan 2013 15:34:55 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rob Herring (2013-01-06 06:58:40)
> On 01/06/2013 08:21 AM, Denis Efremov wrote:
> > The symbol of_fixed_clk_setup is exported and annotated __init.
> > This looks like section mismatch.
> > Fix this by removing the __init annotation of of_fixed_clk_setup.
> > 
> > Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> 
> Mike should take this.
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>
>

Thanks for catching this Denis.  Taken into clk-next.

Regards,
Mike
 
> > ---
> >  drivers/clk/clk-fixed-rate.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
> > index af78ed6..a53b53b 100644
> > --- a/drivers/clk/clk-fixed-rate.c
> > +++ b/drivers/clk/clk-fixed-rate.c
> > @@ -85,7 +85,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
> >  /**
> >   * of_fixed_clk_setup() - Setup function for simple fixed rate clock
> >   */
> > -void __init of_fixed_clk_setup(struct device_node *node)
> > +void of_fixed_clk_setup(struct device_node *node)
> >  {
> >       struct clk *clk;
> >       const char *clk_name = node->name;
> >
