Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab3LJWaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:30:17 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54644 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3LJWaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:30:15 -0500
Message-ID: <52A795F3.9040107@linaro.org>
Date: Tue, 10 Dec 2013 14:30:11 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        xen-devel@lists.xen.org, Prarit Bhargava <prarit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC][PATCH 3/3] timekeeping: Fix potential lost
 pv notification of time change
References: <1386652197-7035-1-git-send-email-john.stultz@linaro.org> <1386652197-7035-4-git-send-email-john.stultz@linaro.org> <52A6DB24020000780010BAC6@nat28.tlf.novell.com>
In-Reply-To: <52A6DB24020000780010BAC6@nat28.tlf.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 12:13 AM, Jan Beulich wrote:
>>>> On 10.12.13 at 06:09, John Stultz <john.stultz@linaro.org> wrote:
>>  static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
>> -						u32 shift)
>> +						u32 shift, int *action)
> With plain int used here, ...
>
>> @@ -1369,7 +1369,7 @@ static void update_wall_time(void)
>>  	struct timekeeper *tk = &shadow_timekeeper;
>>  	cycle_t offset;
>>  	int shift = 0, maxshift;
>> -	unsigned int action;
>> +	unsigned int action = 0;
> ... and unsigned int used here, ...
>
>> @@ -1404,7 +1404,7 @@ static void update_wall_time(void)
>>  	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
>>  	shift = min(shift, maxshift);
>>  	while (offset >= tk->cycle_interval) {
>> -		offset = logarithmic_accumulation(tk, offset, shift);
>> +		offset = logarithmic_accumulation(tk, offset, shift, &action);
> ... does this compile without warning for you?

It does compile without a warning, but I'll fix it none the less!

Thanks for pointing this out!
-john

