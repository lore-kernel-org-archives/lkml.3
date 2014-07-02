Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaGBDof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 23:44:35 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46392 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaGBDod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 23:44:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>,
        "Steven Rostedt" <rostedt@goodmis.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53B209E5.1050701@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1404172599-10171-1-git-send-email-sboyd@codeaurora.org>
 <20140630205211.3d114169@gandalf.local.home>
 <53B209E5.1050701@codeaurora.org>
Message-ID: <20140702034420.32686.53303@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: Add tracepoints for hardware operations
Date: Tue, 01 Jul 2014 20:44:20 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2014-06-30 18:07:49)
> On 06/30/14 17:52, Steven Rostedt wrote:
> > On Mon, 30 Jun 2014 16:56:39 -0700
> > Stephen Boyd <sboyd@codeaurora.org> wrote:
> >
> >> @@ -483,10 +486,12 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
> >>              return;
> >>  
> >>      if (__clk_is_prepared(clk)) {
> >> +            trace_clk_unprepare(clk);
> > Does it make sense to do these when clk->ops->unprepared_unused or
> > uprepare is not set?
> >
> > You can use DEFINE_EVENT_CONDITIONAL() and add as condition:
> >
> >    clk->ops->unprepared_unused || clk->ops->unprepare
> >
> 
> Neat. I don't know if we actually want to do that though. If we always
> record an event even when the hardware doesn't support the operation we
> get information about events happening to the clock from a software
> perspective. If that isn't important, then we can probably just put it
> under the if conditions.

+1 for recording the tree walk even if no hardware operation is backing
it.

Regards,
Mike

> 
> >
> >>              if (clk->ops->enable) {
> >>                      ret = clk->ops->enable(clk->hw);
> >>                      if (ret) {
> >> @@ -945,6 +965,7 @@ static int __clk_enable(struct clk *clk)
> >>                              return ret;
> > It may make even more sense to add the tracepoints within the if
> > statement. Especially if you have a return on error.
> >
> >
> 
> Right. I was thinking that no "clk*_complete" event would mean there was
> some error. Detecting that case is not so easy though. It may be better
> to always have the completion event so we know how long hardware
> operations take and so that error handling is simpler.
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
