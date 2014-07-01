Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaGABL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:11:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10337 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751246AbaGABL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:11:57 -0400
Date: Mon, 30 Jun 2014 21:11:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Add tracepoints for hardware operations
Message-ID: <20140630211155.18fbffc8@gandalf.local.home>
In-Reply-To: <53B209E5.1050701@codeaurora.org>
References: <1404172599-10171-1-git-send-email-sboyd@codeaurora.org>
	<20140630205211.3d114169@gandalf.local.home>
	<53B209E5.1050701@codeaurora.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 18:07:49 -0700
Stephen Boyd <sboyd@codeaurora.org> wrote:

> >
> >>  		if (clk->ops->enable) {
> >>  			ret = clk->ops->enable(clk->hw);
> >>  			if (ret) {
> >> @@ -945,6 +965,7 @@ static int __clk_enable(struct clk *clk)
> >>  				return ret;
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

You could also have the event record the ret as well.

-- Steve
