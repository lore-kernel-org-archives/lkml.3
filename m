Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbaGRNiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:38:25 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44402 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761812AbaGRNiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:38:22 -0400
Message-ID: <53C92350.40204@linaro.org>
Date: Fri, 18 Jul 2014 08:38:24 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] printk: initialize syslog_prev and console_prev
References: <1405606151-19875-1-git-send-email-elder@linaro.org> <1405606151-19875-2-git-send-email-elder@linaro.org> <20140718104338.GX6774@pathway.suse.cz>
In-Reply-To: <20140718104338.GX6774@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 05:43 AM, Petr Mládek wrote:
> On Thu 2014-07-17 09:09:06, Alex Elder wrote:
>> Two global variables, "syslog_prev" and "console_prev", maintain a
>> copy of the flags value used in the log record most recently
>> formatted for syslog or the console, respectively.

. . .

>> @@ -2148,7 +2148,7 @@ again:
>>  			/* messages are gone, move to first one */
>>  			console_seq = log_first_seq;
>>  			console_idx = log_first_idx;
>> -			console_prev = 0;
>> +			console_prev = LOG_NEWLINE;
>>  		} else {
>>  			len = 0;
>>  		}
> 
> It would make sense to add '\n' if we skip something and the previous
> copied line was continuous. This would change the behavior, so we
> should do this in separate patch.

I'm working up a v3 of this series and have inserted a patch
that implements this at the beginning.

> Anyway, it makes sense to reset the flag to LOG_NEWLINE.
> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>

Thanks a lot.

					-Alex

