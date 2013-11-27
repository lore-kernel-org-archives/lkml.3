Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3K0QnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:43:23 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52810 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab3K0QnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:43:22 -0500
MIME-Version: 1.0
In-Reply-To: <529613F5.7080503@akamai.com>
References: <1385533070-7604-1-git-send-email-felipe.contreras@gmail.com>
	<1385533070-7604-2-git-send-email-felipe.contreras@gmail.com>
	<529613F5.7080503@akamai.com>
Date: Wed, 27 Nov 2013 10:43:21 -0600
Message-ID: <CAMP44s1KTTXcdcziAG-fqk7giEakPjz5EZGYJGpW9TPaLTQAAA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] panic: setup panic_timeout early
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jason Baron <jbaron@akamai.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 9:47 AM, Jason Baron <jbaron@akamai.com> wrote:
> On 11/27/2013 01:17 AM, Felipe Contreras wrote:
>> Otherwise we might not reboot when the user needs it the most (early
>> on).
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>  kernel/panic.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/panic.c b/kernel/panic.c
>> index b6c482c..3456652 100644
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>> @@ -468,9 +468,14 @@ EXPORT_SYMBOL(__stack_chk_fail);
>>
>>  #endif
>>
>> -core_param(panic, panic_timeout, int, 0644);
>>  core_param(pause_on_oops, pause_on_oops, int, 0644);
>>
>> +static int __init set_panic_timeout(char *val)
>> +{
>> +     return kstrtoint(val, 0, &panic_timeout);
>> +}
>> +early_param("panic_timeout", set_panic_timeout);
>> +
>>  static int __init oops_setup(char *s)
>>  {
>>       if (!s)
>
> hmm....so this changes the comand-line parameter panic=x  to:
> panic_timeout=x. The naming might not be the best, but we are
> really stuck with it at this point.

Hmm, right, it should be "panic".

-- 
Felipe Contreras
