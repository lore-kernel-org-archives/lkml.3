Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbbAVS72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:59:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45876 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbbAVS7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:59:25 -0500
Date: Thu, 22 Jan 2015 10:59:23 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 2/4] clk: Make clk API return per-user struct clk
 instances
Message-ID: <20150122185923.GL27202@codeaurora.org>
References: <1421847039-29544-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421847039-29544-3-git-send-email-tomeu.vizoso@collabora.com>
 <20150122010136.GH27202@codeaurora.org>
 <54C0DBD6.2000502@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C0DBD6.2000502@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Tomeu Vizoso wrote:
> On 01/22/2015 02:01 AM, Stephen Boyd wrote:
> > BTW, please try and fixup checkpatch warnings.
> 
> What were you thinking of specifically? I'm running it with
> --max-line-length=106 and the other warnings are in clk-test.c that I
> still have to polish when I get some time.

I can see that sometimes we exceed the 80 character limits that
are configured by default. We mostly stick to 80 in this file it
seems so I'm not sure why 106 is being used.

> > 
> > And we do it here where we could remove the #ifdef.
> 
> Yeah, I tried to reduce the ifdefing back then and this is the simplest
> I could come up with. The reason for clk_get() to call
> __clk_create_clk() directly is that it has more relevant information
> with which to tag the per-user clk.
> 
> of_clk_get_by_name() has the name of the node but not the dev_id, which
> in my testing looked as much less useful when debugging who did what to
> a clock.
> 

Agreed. But didn't we add __of_clk_get_by_name() so that we could
pass the dev_id and con_id to it? If we did that then all the
relevant information is there and we can call __clk_create_clk()
directly instead of relying on the caller to do it.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
