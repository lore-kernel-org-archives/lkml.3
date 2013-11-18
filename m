Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab3KRPe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:34:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33392 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3KRPeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:34:21 -0500
Message-ID: <528A3373.7040205@ti.com>
Date: Mon, 18 Nov 2013 09:34:11 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>,
        Tobias Diedrich <ranma+xen@tdiedrich.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] cpufreq: stats: Do not populate stats when policy->cur
 has no exact match
References: <1384561243-30391-1-git-send-email-nm@ti.com>	<1423628.uM8DtnYzDe@vostro.rjw.lan>	<5287010F.9000508@linaro.org>	<528A2D59.3080001@ti.com> <CAKohpokzk2Zr7G+GV9d9Bc73WJHNMg01dfAJcxbwCGKFt9BpOw@mail.gmail.com>
In-Reply-To: <CAKohpokzk2Zr7G+GV9d9Bc73WJHNMg01dfAJcxbwCGKFt9BpOw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 09:22 AM, Viresh Kumar wrote:
> On 18 November 2013 20:38, Nishanth Menon <nm@ti.com> wrote:
>> On 11/15/2013 11:22 PM, viresh kumar wrote:
> 
>>> I have a untested patch for this. If this looks okay, Nishant can you please try
>>> below patch? With some fixups from your side :)
>>
>> http://pastebin.mozilla.org/3628975
>>
>> I agree that it does show something
> 
> Were you required to update it or fix it? Or you used it as is?

as is - though manually applied ;)

> 
>> but would we not rather prefer to
>> stick with the entries available in freq_table than have to deal with
>> invalid frequencies that may be provided by the driver? for example:
>> how do we in stat know that there will only be one invalid frequency
>> request?
> 
> We don't have to. Actually there is nothing like an invalid freq, as system
> is able to run with it. Its only if kernel is allowed to switch to that
> frequency or not.

depends on how we look at it.. if we consider freq_table as a list of
valid frequencies, anything that is not in there is an invalid entry.
why should stat support it when freq_table is enforced by cpufreq layer?

> 
> This information will be useful for platform developers to know that kernel
> was running on some out of freq-table freq for some time, what that
> frequency was their job to find out and kernel doesn't need to print all
> out of range frequencies. Keeping a single entry for that is more than
> sufficient..
yeah, I guessed that.. no strong feelings other wise..

> 
> Though I personally didn't like: 4294967295 to be printed there.. Will
> see if I can improve that, but its obviously looks better than failing
> in cpufreq-stats..

> 
>> there are some patch wrapping that thunderbird tends to do - I prefer
>> mutt that way, when I need to send inline patches :).
> 
> There are steps in Documentation/email-clients.txt to get that fixed.. I
> have used thunderbird for several years and never found anything
> wrong with sending inline patches..

:) -> https://patchwork.kernel.org/patch/3192211/ shows how confused
my git am  feels ;)


-- 
Regards,
Nishanth Menon
