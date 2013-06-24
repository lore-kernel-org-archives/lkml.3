Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3FXRuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:50:12 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33408 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3FXRuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:50:10 -0400
Message-ID: <51C886CF.4010001@linaro.org>
Date: Mon, 24 Jun 2013 10:50:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Thomas Gleixner <tglx@linutronix.de>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-3-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de> <51C44A09.9010402@citrix.com> <alpine.DEB.2.02.1306212328350.4013@ionos.tec.linutronix.de> <51C824A8.1080305@citrix.com> <alpine.DEB.2.02.1306241753080.4013@ionos.tec.linutronix.de> <51C87B26.3010904@citrix.com>
In-Reply-To: <51C87B26.3010904@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 10:00 AM, David Vrabel wrote:
> On 24/06/13 17:30, Thomas Gleixner wrote:
>> @@ -508,7 +509,7 @@ int do_settimeofday(const struct timespec *tv)
>>   
>>   	tk_set_xtime(tk, tv);
>>   
>> -	timekeeping_update(tk, true, true);
>> +	timekeeping_update(tk, true, true, true);
> These three booleans in a row is getting a bit opaque. How about I also
> change it to a set of flags?  e.g.,
>
> timekeeping_updated(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);

Yea. I'm not a fan of the bool arguments to functions (which I have to 
look up every time as which bool is which).

The bitflag approach is nicer in my mind, since its a bit more explicit 
when reading the code.

The other approach would be to have different function calls 
(timekeeping_clear_ntp, timekeeping_mirror, timekeeping_clock_was_set), 
which call into the same back end logic.

thanks
-john
