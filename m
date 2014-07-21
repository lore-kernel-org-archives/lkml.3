Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbaGUO1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:27:45 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59573 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298AbaGUO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:27:44 -0400
Message-ID: <53CD2365.4070707@linaro.org>
Date: Mon, 21 Jul 2014 09:27:49 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, kay@vrfy.org, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] printk: insert newline for truncated records
References: <1405718885-11227-1-git-send-email-elder@linaro.org> <1405718885-11227-7-git-send-email-elder@linaro.org> <20140721115706.GC20751@pathway.suse.cz> <53CD0852.2030706@linaro.org> <20140721135703.GE20751@pathway.suse.cz>
In-Reply-To: <20140721135703.GE20751@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 08:57 AM, Petr Mládek wrote:
> On Mon 2014-07-21 07:32:18, Alex Elder wrote:
>> On 07/21/2014 06:57 AM, Petr Mládek wrote:
>>> On Fri 2014-07-18 16:28:04, Alex Elder wrote:
>>>> If a log record has LOG_PREFIX set, its predecessor record should be
>>>> terminated if it was marked LOG_CONT.
>>>>
>>>> In devkmsg_read(), this condition was being ignored, which would
>>>> lead to such records showing up combined when reading /dev/kmsg.
>>>> Fix this oversight.

. . .

>>>> @@ -1023,9 +1029,13 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
>>>>  
>>>>  		if (buf) {
>>>>  			if (print_prefix(msg, syslog, NULL) +
>>>> -			    text_len + 1 >= size - len)
>>>> +			    text_len + 2 >= size - len)
>>>
>>> It counts the '\n' even when it is not used.
>>> I think that it is even wrong that it calculates prefix when it is not used.
>>
>> That's true, and I have yet another un-posted patch that
>> addresses this problem (well the second one).  I am not
>> going to fix this problem in this patch, but the fix is
>> coming.
>>
>> Now that you're looking at the code I'm touching, you're
>> seeing the same things I did...
>>
>> I think I'll start posting that series later today or
>> tomorrow.   I just hate to get too far ahead of myself.
> 
> I suggest to always wait at least 24 hours before sending another
> version. I think that it is very hard for others to follow if there
> are too many versions in the wild and the code is too changing.
> This is why you get comments basically only from me.

Well, what I'm talking about would be a new series.  But I'll
wait I guess.

FYI, here's what I have already posted:
- This series (v5 has now been posted)
- A "printk: more log flag simplification" series that
  follows this one (had problems; will be reposted as
  a truncated set)

And here are some things I have queued, but have not yet
posted for review:
- A patch that corrects the size calculation issue you
  also noticed in msg_print_text().
- A series that I'm still verifying, which avoids formatting
  all printk() messages repeatedly.

I will try to avoid having too many things out at once.

> Also a night usually helps to sort ideas and go the right direction.
> In fact, I was too fast myself as well. I am going to comment only one
> version per-day from now on :-)

Oh, all right.  :)

>>>>  				break;
>>>>  
>>>> +			if (insert_newline) {
>>>> +				insert_newline = false;
>>>> +				buf[len++] = '\n';
>>>> +			}
>>>>  			if (prefix)
>>>>  				len += print_prefix(msg, syslog, buf + len);
>>>>  			memcpy(buf + len, text, text_len);

. . .

>> Meanwhile, this patch is addressing essentially the same problem
>> in two spots, so I'd like to keep these together rather than
>> splitting it in two.
> 
> I do not have strong opinion here.

I will keep it as I posted in v5.  I moved this patch
earlier in the series, but did not combine it with the
first one.

>> I will move this patch earlier in the series, however, making
>> it follow patch 1.
> 
> Sounds good.

Thanks for all your timely reviews, Petr.

					-Alex
