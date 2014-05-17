Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaEQVet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:34:49 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:58172 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaEQVer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:34:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140517202255.GF15585@mwanda>
References: <1400350980-30455-2-git-send-email-peter.senna@gmail.com>
	<20140517202255.GF15585@mwanda>
Date: Sat, 17 May 2014 23:34:46 +0200
Message-ID: <CA+MoWDqLtr-O=VQNC7qqNUJvWkEPtVr8cw9t5sB=adQWkywLZw@mail.gmail.com>
Subject: Re: [PATCH 2/4] cpupower: Remove redundant error check
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Cox <alan@linux.intel.com>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 10:22 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Sat, May 17, 2014 at 08:22:58PM +0200, Peter Senna Tschudin wrote:
>> diff --git a/tools/power/cpupower/utils/cpufreq-set.c b/tools/power/cpupower/utils/cpufreq-set.c
>> index a416de8..4e2f35a 100644
>> --- a/tools/power/cpupower/utils/cpufreq-set.c
>> +++ b/tools/power/cpupower/utils/cpufreq-set.c
>> @@ -320,12 +320,11 @@ int cmd_freq_set(int argc, char **argv)
>>
>>               printf(_("Setting cpu: %d\n"), cpu);
>>               ret = do_one_cpu(cpu, &new_pol, freq, policychange);
>> -             if (ret)
>> +             if (ret) {
>> +                     print_error();
>>                       break;
>
> Just return directly instead of break return;
>
>> +             }
>>       }
>>
>> -     if (ret)
>> -             print_error();
>> -
>>       return ret;
>
> Are you sure this patch is correct?  Theoretically, it's possible to
> reach the end of this function without going hitting the
> "ret = do_one_cpu(...);" assignment.
>
> Don't be fooled by the "int ret = 0;" initialization, that is a trick
> initialization to mislead the unwary.  By the end of the do while loop
> then "ret" is always -1.
I have missed that, thank you for pointing this out. This patch is
wrong and should not be applied, please ignore it.

Dan, should I just leave this file as it is?

>
> regards,
> dan carpenter
>



-- 
Peter
