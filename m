Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaATIHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:07:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38851 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaATIHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:07:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAPtuhTikj38yKy-=uF7O+VFG_N4AWee23f9woemM318fM3V4VQ@mail.gmail.com>
References: <1390110907-29918-1-git-send-email-sj38.park@gmail.com>
 <20140119173712.GA26481@kroah.com> <CAPtuhTikj38yKy-=uF7O+VFG_N4AWee23f9woemM318fM3V4VQ@mail.gmail.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Mon, 20 Jan 2014 17:07:23 +0900
Message-ID: <CAEjAshoh5ucPJA6pG1sx+7HGCYjHzCKtbzmH+GYJwpefDYLwJg@mail.gmail.com>
Subject: Re: [PATCH] clk: export __clk_get_hw for re-use in others
To: Mike Turquette <mturquette@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 4:47 PM, Mike Turquette <mturquette@linaro.org> wrote:
> On Sun, Jan 19, 2014 at 9:37 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Sun, Jan 19, 2014 at 02:55:07PM +0900, SeongJae Park wrote:
>>> Following build comes while modprobe process:
>>> > ERROR: "__clk_get_hw" [drivers/clk/clk-max77686.ko] undefined!
>>> > make[2]: *** [__modpost] Error 1
>>> > make[1]: *** [modules] Error 2
>>>
>>> Export the symbol to fix it and for other part's usecase.
>>>
>>> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
>>> ---
>>>  drivers/clk/clk.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>>> index 2b38dc9..3883fba 100644
>>> --- a/drivers/clk/clk.c
>>> +++ b/drivers/clk/clk.c
>>> @@ -575,6 +575,7 @@ struct clk_hw *__clk_get_hw(struct clk *clk)
>>>  {
>>>       return !clk ? NULL : clk->hw;
>>>  }
>>> +EXPORT_SYMBOL_GPL(__clk_get_hw);
>>
>> __ functions should usually only be for "internal" use, why does this
>> get exported to modules?  Why not just put it in a .h file?
>
> It was originally used only within the clock core but it is sensible
> for hardware-specific clock drivers to use this as well. I plan to
> audit all of the double-underscore functions in
> include/linux/clk-provider.h for 3.15.
>
> Regards,
> Mike
>
Thank you very much for answering about it, Mike.

I agree Greg's indication and think Mike's explanation is reasonable.

So, I think it would be better to just export the symbol now
because it would be easier for future functions renaming and
similar issues were solved in this way in past:
https://lkml.org/lkml/2013/4/15/50

Or, maybe I can change the client code of __clk_get_hw to not use the function.

What do you think would be better to fix this build error? Or, do you
have better idea?
I will respect your opinion.

Thanks and Regards.
SeongJae Park.

>>
>> greg k-h
