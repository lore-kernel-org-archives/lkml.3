Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855Ab3ECIyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:54:13 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:33481 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762800Ab3ECIyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpZ+-6b3kPyNacPQ33=Ssdjs=fvFxkr4iSUT_hm1YzVTg@mail.gmail.com>
References: <1367325906-23045-1-git-send-email-fabio.baltieri@linaro.org>
	<CAPDyKFpZ+-6b3kPyNacPQ33=Ssdjs=fvFxkr4iSUT_hm1YzVTg@mail.gmail.com>
Date: Fri, 3 May 2013 10:54:09 +0200
Message-ID: <CAPDyKFq6iQ21QosEH_WqGCetXfaO1uecvK7+WzjZJDkK8r3SxA@mail.gmail.com>
Subject: Re: [PATCH] clk: ux500: clk-sysctrl: handle clocks with no parents
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2013 10:51, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 30 April 2013 14:45, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
>> Fix clk_reg_sysctrl() to set main clock registers of new struct
>> clk_sysctrl even if the registered clock has no parents.
>>
>> This fixes an issue where "ulpclk" was registered with all clk->reg_*
>> fields uninitialized, causing a -EINVAL error from clk_prepare().
>>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
>> ---
>>  drivers/clk/ux500/clk-sysctrl.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/ux500/clk-sysctrl.c b/drivers/clk/ux500/clk-sysctrl.c
>> index bc7e9bd..e364c9d 100644
>> --- a/drivers/clk/ux500/clk-sysctrl.c
>> +++ b/drivers/clk/ux500/clk-sysctrl.c
>> @@ -145,7 +145,13 @@ static struct clk *clk_reg_sysctrl(struct device *dev,
>>                 return ERR_PTR(-ENOMEM);
>>         }
>>
>> -       for (i = 0; i < num_parents; i++) {
>> +       /* set main clock registers */
>> +       clk->reg_sel[0] = reg_sel[0];
>> +       clk->reg_bits[0] = reg_bits[0];
>> +       clk->reg_mask[0] = reg_mask[0];
>> +
>> +       /* handle clocks with more than one parent */
>> +       for (i = 1; i < num_parents; i++) {
>>                 clk->reg_sel[i] = reg_sel[i];
>>                 clk->reg_bits[i] = reg_bits[i];
>>                 clk->reg_mask[i] = reg_mask[i];
>> --
>> 1.8.2
>>
>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> This is bugfix, should go "stable" as well?

Stable means 3.10 rcs, since the abx500 clk tree was added for 3.10.

>
> Kind regards
> Ulf Hansson
