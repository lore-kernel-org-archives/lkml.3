Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3ISNRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:17:42 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56373 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3ISNRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:17:40 -0400
Message-ID: <523AF50E.1040502@linux.vnet.ibm.com>
Date: Thu, 19 Sep 2013 18:28:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: Regression on cpufreq in v3.12-rc1
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com> <45987104.t6r4hvPgQn@vostro.rjw.lan>	<523AF22F.1010909@linux.vnet.ibm.com> <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
In-Reply-To: <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091913-8256-0000-0000-0000094AF30C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 06:25 PM, Linus Walleij wrote:
> On Thu, Sep 19, 2013 at 2:46 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>>>> I don't really know if this is the right solution at all, so please
>>>> help me out here... if you want that patch I can send it once
>>>> I understand this properly.
>>
>> IIRC, recent kernels didn't return 0 or any error code when the !policy
>> condition was matched. So can you check whether this problem occurs with
>> 3.11 or 3.10 as well?
> 
> v3.11 works fine.
> 
> The problem is not what it returns, the system seems to survive no matter
> whether it returns 0 or 17 or whatever.
> 

Of course. What I intended to say was that I don't recall recent kernels
returning _anything_ on !policy. So there wasn't any sudden change in _that_
piece of code, AFAIR.

> The problem is that sometimes in the v3.12 kernel cycle we got a
> BUG() crash instead of some random value back for calling early.
> 

Yep, and that's most likely due to some change in ordering of calls somewhere,
which makes calls to lock_policy_rwsem_read() before it is safe to do so,
rather than anything related to how lock_policy_rwsem_read() handles the call.

>> So I think we should first identify (bisect?) and understand what caused that
>> particular change and then we will be in a position to evaluate whether the
>> patch you proposed would be the right fix or not.
> 
> I'll see if I can get a bisect going, the problem is that I upload the
> kernel over the serial port so this isn't a very quick procedure :-(
> 

Hmmm.. :-/

Regards,
Srivatsa S. Bhat

