Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161372Ab3DGCpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 22:45:46 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:49598 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161279Ab3DGCpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 22:45:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAMo8BfJd9U+HAPqh-6XThHCXMCP35oLEyMXhYhPX_ZE5utD2LQ@mail.gmail.com>
References: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com>
	<254789F5-7950-4239-AB7B-2DB9DC73565F@dubeyko.com>
	<5159EC3D.2020501@gmail.com>
	<1364884045.3301.18.camel@slavad-ubuntu>
	<CAMo8Bf+83t3ML_Ctr4V-pVL7Meei=pdOeC5cgtrPJB12tOcGtA@mail.gmail.com>
	<CAMo8BfKgTPO6AJng6zo1my4K_PivC1gJFQmcvy8q=iDYWSO2Pw@mail.gmail.com>
	<20130405015327.GA319@kernel.org>
	<CAMo8Bf+ccoU7jccOsxoyPqo2o8HaHhnuiocoNj1j67+S07aq_g@mail.gmail.com>
	<CAKYAXd_V4ZjozTn2F-VtQwrsQ229JsBqL8RaFCYE66MhXvBrUA@mail.gmail.com>
	<CAMo8BfJOEdZ3OzZUG6fU_sdMzaHCEUkin1cMwzoezbsScby5=A@mail.gmail.com>
	<CAKYAXd_q2oUiQBoLX77Yurs1OQ5cMACCGSYFOqgjPhxhErp9hA@mail.gmail.com>
	<CAMo8BfJd9U+HAPqh-6XThHCXMCP35oLEyMXhYhPX_ZE5utD2LQ@mail.gmail.com>
Date: Sun, 7 Apr 2013 11:45:44 +0900
Message-ID: <CAKYAXd9qQiahr0OMmKaVLYU6HH2izEJ8BTg88ELbd0qyZp1UEw@mail.gmail.com>
Subject: Re: mkfs.f2fs gets stuck with "blk_update_request: bio idx 0 >= vcnt
 0" on 3.8
From: Namjae Jeon <linkinjeon@gmail.com>
To: Max Filippov <jcmvbkbc@gmail.com>, Shaohua Li <shli@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/7, Max Filippov <jcmvbkbc@gmail.com>:
> On Sun, Apr 7, 2013 at 4:36 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
>>
>>
>> 2013/4/6 Max Filippov <jcmvbkbc@gmail.com>
>>>
>>> Hi Namjae,
>>>
>>> On Fri, Apr 5, 2013 at 11:57 AM, Namjae Jeon <linkinjeon@gmail.com>
>>> wrote:
>>> > Hi. Max.
>>> >
>>> > I have a question.
>>> > Your mmc host driver set to host->max_discard_to by some value instead
>>> > of not zero ?
>>>
>>> I believe it's zero, because the only place where I can see it
>>> initialized
>>> (sdhci_add_host in the drivers/mmc/host/sdhci.c) is not built in my
>>> configuration.
>>>
>>  -> sorry for private mail. There is confusing to me about your previous
>> mail.
>> I think that max_discard_sectors is set to 0xFFFFFFFF(UINT_MAX).
>> because mmc core set to it by UINT_MAX when host-<max_discard_to is zero.
>> So I guess it can try to be merged to over 4GB size.
>>
>> unsigned int mmc_calc_max_discard(struct mmc_card *card)
>> {
>> struct mmc_host *host = card->host;
>> unsigned int max_discard, max_trim;
>>
>> if (!host->max_discard_to)
>> return UINT_MAX; ==> It should be UINT_MAX >> 9;
>>
>> unfortunely, I don't have mmc device and card had over 4GB size.
>> So If you agree, Could you try to test after changing  above code
>> UINT_MAX
>> => UINT_MAX >> 9 ?
>
> This fixes the issue too. Requests do not merge, although
> attempt_plug_merge
> returns ELEVATOR_BACK_MERGE.
Okay, Thanks for your test.
As I guess, this issue is  caused from max discards setting of mmc core.
I will try to commit this patch to mmc driver.


Thanks Max.

>
> --
> Thanks.
> -- Max
>
