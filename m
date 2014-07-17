Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589AbaGQQEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:04:31 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:61473 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaGQQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:04:30 -0400
Message-ID: <53C7F40F.7040404@linaro.org>
Date: Thu, 17 Jul 2014 11:04:31 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Kay Sievers <kay@vrfy.org>
CC: akpm@linux-foundation.org, pmladek@suse.cz, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] printk: start simplifying some flags
References: <1405606151-19875-1-git-send-email-elder@linaro.org> <1405612760.12363.14.camel@joe-AO725>
In-Reply-To: <1405612760.12363.14.camel@joe-AO725>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 10:59 AM, Joe Perches wrote:
> Again adding Kay Sievers.
> 
> Kay wrote almost all of this originally and should
> be able to review it.
> 
> Alex, if this series is resubmitted, do please cc Kay.

Yes, sorry about that.  I meant to but forgot.  Thanks for
forwarding.

					-Alex

> It does seem reasonable to me, thanks for doing it.
> 
> On Thu, 2014-07-17 at 09:09 -0500, Alex Elder wrote:
>> Each log record has a "flags" field.  The flags keep track of, for
>> instance, whether the record was saved in its entirety (as opposed
>> to being one of multiple records that should be merged as a single
>> unit).  A log record's flags field alone is not currently sufficient
>> to know how the record should be formatted; you need to know the
>> previous record's flags field as well.  I found understanding the
>> real effect of various combinations of these flags to be very
>> difficult, and was moved to try to do something about that.
>>
>> This series includes three patches that begin the process of
>> simplifying how these flags are used and interpreted.  They include
>> very long, detailed explanations (as small patches often do) because
>> I want my reasoning to be very clear and examined very closely.  I
>> really don't want to break printk()...
>>
>> The first patch changes how two global variables are initialized,
>> allowing the second patch to assume they always hold certain values.
>>
>> The second patch simplifies some code based on the observation that
>> the LOG_CONT and LOG_NEWLINE flags are mutually exclusive.
>>
>> The third and fourth patch fix a bug in two places.  The bug is
>> that a LOG_PREFIX in a record should implicitly terminate its
>> predecessor, even if the predecessor was marked LOG_CONT.
>>
>> The fifth patch inserts a newline in /dev/kmsg output in the
>> event a LOG_PREFIX record follows a LOG_CONT record.
>>
>> One trivial final patch is included at the end of the series.
>>
>> 					-Alex
>>
>> History:
>> v2: - Added a patch to initialize two globals with LOG_NEWLINE.
>>     - Changed the (now) second patch to argue that LOG_CONT and
>>       LOG_NEWLINES are mutally exclusive.
>>     - Added a patch to insert a newline in one case in devkmsg_read().
>>     - Added some extra parentheses in some conditions, as requested.
>>     - Fixed and updated some header commentary.
>>     - Deleted a hunk in the typo patch, as requested.
>>
>> This series, based on v3.16-rc5, is available here:
>>     http://git.linaro.org/landing-teams/working/broadcom/kernel.git
>>     Branch review/printk-flags-v2
>>
>> Alex Elder (6):
>>   printk: initialize syslog_prev and console_prev
>>   printk: LOG_CONT and LOG_NEWLINE are opposites
>>   printk: honor LOG_PREFIX in devkmsg_read()
>>   printk: honor LOG_PREFIX in msg_print_text()
>>   printk: insert newline in devkmsg_read()
>>   printk: correct some more typos
>>
>>  kernel/printk/printk.c | 63 +++++++++++++++++++++++++++-----------------------
>>  1 file changed, 34 insertions(+), 29 deletions(-)
>>
> 
> 
> 

