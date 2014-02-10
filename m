Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaBJKXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:23:54 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:40939 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBJKXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:23:48 -0500
MIME-Version: 1.0
In-Reply-To: <20140210091135.GR26722@mwanda>
References: <2067517.LR5DRBeXLF@daeseok-laptop.cloud.net>
	<20140210091135.GR26722@mwanda>
Date: Mon, 10 Feb 2014 19:23:46 +0900
Message-ID: <CAHb8M2AzdaFLyNkUhU8uTb_ztt3NoEW0QO8px1FRuHdK2cT4FA@mail.gmail.com>
Subject: Re: [PATCH] staging : android : fix checkpatch issues
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>,
        ohaugan@codeaurora.org, Rom Lemarchand <romlem@google.com>,
        devel <devel@driverdev.osuosl.org>, konkers <konkers@android.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ccross@android.com,
        Rebecca Zavin <rebecca@android.com>, prtvar.b@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing.

Yes, I just followed by reports of checkpatch.pl.

But I don't understand why I can use of seq_puts() in the middle of
seq_printf() calls.
I have been trying to search why that is not good but I didn't find
anything about that.
And I saw patches which were already merged similar with this patch.

You can see with this url
https://github.com/torvalds/linux/commit/2d219c518882d2b2bac77742a6a8979c9dad051a
https://github.com/mirrors/linux-2.6/commit/7aff38176e79a22b1749c2af74060028298e6a45

If you don't mind, let me know why it is not good.

Thanks.
Daeseok Youn

2014-02-10 18:11 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Mon, Feb 10, 2014 at 10:59:14AM +0900, Daeseok Youn wrote:
>> @@ -1376,14 +1376,14 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
>>               }
>>       }
>>       mutex_unlock(&dev->buffer_lock);
>> -     seq_printf(s, "----------------------------------------------------\n");
>> +     seq_puts(s, "----------------------------------------------------\n");
>>       seq_printf(s, "%16.s %16zu\n", "total orphaned",
>>                  total_orphaned_size);
>
> This kind of thing where you put a seq_puts() in the middle of a string
> of seq_printf() calls is not good.  We only make checkpatch.pl warn
> about it to see if patch submitters are paying attention and to test the
> patience of reviewers.
>
> regards,
> dan carpenter
>
