Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3JCHGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:06:30 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:57543 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3JCHG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:06:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon=PO+U2DGJQJKa+9MhxoVC3ALnJYjv8_DEUDMivGZREQ@mail.gmail.com>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
	<1380370138-3513-11-git-send-email-sachin.kamat@linaro.org>
	<CAKohpon=PO+U2DGJQJKa+9MhxoVC3ALnJYjv8_DEUDMivGZREQ@mail.gmail.com>
Date: Thu, 3 Oct 2013 12:36:28 +0530
Message-ID: <CAK9yfHytPyvqU1N4KJKQq_-XNz=s_MCv3kVAKzp8497ANinwxA@mail.gmail.com>
Subject: Re: [PATCH 11/11] pinctrl: plgpio: Remove redundant of_match_ptr
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2013 10:07, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 28 September 2013 17:38, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> The data structure of_match_ptr() protects is always compiled in.
>
> of_match_ptr() isn't a data structure..

Yes you are right. of_match_ptr() is a macro. The data structure here
refers to its argument and not of_match_ptr() itself.

>And also what does "protects" mean here?

It just means that of_match_ptr()  avoids an undefined reference error
had CONFIG_OF been used around the data structures definition by
making the pointer NULL.

>
>> Hence of_match_ptr() is not needed.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/pinctrl/spear/pinctrl-plgpio.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
>> index 0a7f0bdb..ff2940e 100644
>> --- a/drivers/pinctrl/spear/pinctrl-plgpio.c
>> +++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
>> @@ -735,7 +735,7 @@ static struct platform_driver plgpio_driver = {
>>                 .owner = THIS_MODULE,
>>                 .name = "spear-plgpio",
>>                 .pm = &plgpio_dev_pm_ops,
>> -               .of_match_table = of_match_ptr(plgpio_of_match),
>> +               .of_match_table = plgpio_of_match,
>>         },
>>  };
>
> Patch is okay otherwise.

Hope to have your ack on this :)
Thanks for reviewing.

-- 
With warm regards,
Sachin
