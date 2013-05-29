Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965005Ab3E2Hvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:51:32 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:65531 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806Ab3E2Hvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:51:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <519461BB.3010209@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1368124502-18830-1-git-send-email-skannan@codeaurora.org>
 <519461BB.3010209@codeaurora.org>
Message-ID: <20130529075126.6058.58923@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v2 1/2] clk: Disable unused clocks after deferred probing is done
Date: Wed, 29 May 2013 00:51:26 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Saravana Kannan (2013-05-15 21:34:03)
> On 05/09/2013 11:35 AM, Saravana Kannan wrote:
> > With deferred probing, late_initcall() is too soon to declare a clock as
> > unused. Wait for deferred probing to finish before declaring a clock as
> > unused. Since deferred probing is done in late_initcall(), do the unused
> > check to late_initcall_sync.
> >
> > Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> > ---
> >   drivers/clk/clk.c |    2 +-
> >   1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index fe4055f..5ecb64c 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -534,7 +534,7 @@ static int clk_disable_unused(void)
> >
> >       return 0;
> >   }
> > -late_initcall(clk_disable_unused);
> > +late_initcall_sync(clk_disable_unused);
> >
> >   /***    helper functions   ***/
> 
> Mike,
> 
> Thoughts? Picking it up? Removing the existing auto-disable code (I 
> think they are still useful)?
> 

Hi Saravana,

I've taken this into clk-next for testing.

Regards,
Mike

> -Saravana
> 
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
