Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaBGXgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 18:36:40 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59276 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaBGXgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 18:36:38 -0500
Message-ID: <52F56E03.7010805@gmail.com>
Date: Fri, 07 Feb 2014 15:36:35 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v5 00/14] Add support for MSM's mmio clock/reset controller
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>  <52F45DEE.8020400@gmail.com> <1391749891.15777.31.camel@joe-AO722>  <52F53642.3030606@gmail.com> <1391806318.28199.6.camel@joe-AO722>
In-Reply-To: <1391806318.28199.6.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/2014 12:51 PM, Joe Perches wrote:
> On Fri, 2014-02-07 at 11:38 -0800, Frank Rowand wrote:
>> On 2/6/2014 9:11 PM, Joe Perches wrote:
>>> For patch 1, what checkpatch bug might that be?
> []
>> Sorry, it is patch 2, not patch 1 ("[PATCH v5 02/14] clk: Add set_rate_and_parent() op"):
>>
>>    WARNING: Multiple spaces after return type
>>    #188: FILE: include/linux/clk-provider.h:154:
>>    +       int             (*set_rate_and_parent)(struct clk_hw *hw,
>>
>>    total: 0 errors, 1 warnings, 152 lines checked
> 
> Yup, that one might be a bit aggressive.
> 
> It's a complaint about function pointer declaration style.
> 
> from checkpatch:
> ------------------------------------------------------
> # unnecessary space "type  (*funcptr)(args...)"
> 			elsif ($declare =~ /\s{2,}$/) {
> 				WARN("SPACING",
> 				     "Multiple spaces after return type\n" . $herecurr);
> 			}
> ------------------------------------------------------
> 
> This is warning about style equivalent to declarations like:
> 
> int		foo(int bar);
> 
> checkpatch doesn't warn about declarations of that style,
> so likely checkpatch shouldn't warn about multiple spaces
> after a function pointer return type either.
> 
> I don't have a strong opinion one way or another about it.
> 
> If you think it should be silenced, it could be either
> downgraded to a CHK or removed altogether.

OK, now the warning makes sense.  I was reading "spaces" to mean
the space character instead of white space.

I don't have a strong opinion either, but downgrading to a CHK
would be nice.

It would be less confusing to me (though awkward sounding) to
change the message to "Multiple whitespaces after return type".

-Frank
