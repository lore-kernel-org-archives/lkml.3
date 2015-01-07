Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbbAGUJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:09:49 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:34107 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbAGUJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:09:48 -0500
MIME-Version: 1.0
In-Reply-To: <20150107195244.GB18978@salidar.dom.custoft.eu>
References: <1420394662-20011-1-git-send-email-me@mortis.eu>
	<CAHp75VeZnmsRLV6_gg9Wci03ZEJCk=dRDEkp7DsEubypVvCi3A@mail.gmail.com>
	<20150107195244.GB18978@salidar.dom.custoft.eu>
Date: Wed, 7 Jan 2015 22:09:47 +0200
Message-ID: <CAHp75VeLMaqkTi7kysOZf1a+cqts7nfZPCn=UKR1ysREk_0S_g@mail.gmail.com>
Subject: Re: [PATCH] Fix error-code overwrite bug
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Giel van Schijndel <me@mortis.eu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 9:52 PM, Giel van Schijndel <me@mortis.eu> wrote:
> On Wed, Jan 07, 2015 at 20:37:29 +0200, Andy Shevchenko wrote:
>> On Sun, Jan 4, 2015 at 8:04 PM, Giel van Schijndel <me@mortis.eu> wrote:
>>> Don't overwrite the returned error code with the boolean test used by
>>> the if-statement (otherwise it'd be 1 or 0 always, 1 in the if-block).
>>> ---
>>>  drivers/mtd/nftlmount.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
>>> index 51b9d6a..1cbeb6b 100644
>>> --- a/drivers/mtd/nftlmount.c
>>> +++ b/drivers/mtd/nftlmount.c
>>> @@ -91,7 +91,7 @@ static int find_boot_record(struct NFTLrecord *nftl)
>>>                 /* To be safer with BIOS, also use erase mark as discriminant */
>>>                 if ((ret = nftl_read_oob(mtd, block * nftl->EraseSize +
>>>                                          SECTORSIZE + 8, 8, &retlen,
>>> -                                        (char *)&h1) < 0)) {
>>> +                                        (char *)&h1)) < 0) {
>>
>> Better to move ret = x(); outside of condition. See here:
>> http://permalink.gmane.org/gmane.linux.drivers.mtd/56922
>
> In the sense that this bug wouldn't have occurred when using separate
> assignment and condition checking you're right. It's a style issue
> though, but a relevant one.
>
> So your approach is probably better, though incomplete (like mine), just
> look for the exact same (ret = x() < 0) pattern about 20 lines further
> down the same file. (Yes that's disabled code, but I still believe the
> bug should be fixed considering it's exactly the same class of bug).
>
> So I suggest you resend that ^^ patch you link to with a fix for the
> other instance of the bug fixed as well.

Sounds reasonable. Will do.


-- 
With Best Regards,
Andy Shevchenko
