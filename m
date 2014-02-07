Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaBGUwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:52:05 -0500
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:57312 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751546AbaBGUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:52:01 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:69:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3871:3872:3873:3874:4250:4321:4605:5007:6119:7264:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12683:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: roll64_2e67ff6e4a108
X-Filterd-Recvd-Size: 2385
Message-ID: <1391806318.28199.6.camel@joe-AO722>
Subject: Re: [PATCH v5 00/14] Add support for MSM's mmio clock/reset
 controller
From: Joe Perches <joe@perches.com>
To: frowand.list@gmail.com
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>
Date: Fri, 07 Feb 2014 12:51:58 -0800
In-Reply-To: <52F53642.3030606@gmail.com>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
	 <52F45DEE.8020400@gmail.com> <1391749891.15777.31.camel@joe-AO722>
	 <52F53642.3030606@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 11:38 -0800, Frank Rowand wrote:
> On 2/6/2014 9:11 PM, Joe Perches wrote:
> > For patch 1, what checkpatch bug might that be?
[]
> Sorry, it is patch 2, not patch 1 ("[PATCH v5 02/14] clk: Add set_rate_and_parent() op"):
> 
>    WARNING: Multiple spaces after return type
>    #188: FILE: include/linux/clk-provider.h:154:
>    +       int             (*set_rate_and_parent)(struct clk_hw *hw,
> 
>    total: 0 errors, 1 warnings, 152 lines checked

Yup, that one might be a bit aggressive.

It's a complaint about function pointer declaration style.

from checkpatch:
------------------------------------------------------
# unnecessary space "type  (*funcptr)(args...)"
			elsif ($declare =~ /\s{2,}$/) {
				WARN("SPACING",
				     "Multiple spaces after return type\n" . $herecurr);
			}
------------------------------------------------------

This is warning about style equivalent to declarations like:

int		foo(int bar);

checkpatch doesn't warn about declarations of that style,
so likely checkpatch shouldn't warn about multiple spaces
after a function pointer return type either.

I don't have a strong opinion one way or another about it.

If you think it should be silenced, it could be either
downgraded to a CHK or removed altogether.

