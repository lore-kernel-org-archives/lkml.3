Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3ISOMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:12:06 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:62392 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3ISOME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:12:04 -0400
MIME-Version: 1.0
In-Reply-To: <523AF50E.1040502@linux.vnet.ibm.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<523AF50E.1040502@linux.vnet.ibm.com>
Date: Thu, 19 Sep 2013 19:42:03 +0530
Message-ID: <CAKohpok_u=yUsw3pci90G0sKYy2Ndg8qc9SW+wJm_woSfQhy-g@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 September 2013 18:28, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 09/19/2013 06:25 PM, Linus Walleij wrote:

>> The problem is not what it returns, the system seems to survive no matter
>> whether it returns 0 or 17 or whatever.
>>
>
> Of course. What I intended to say was that I don't recall recent kernels
> returning _anything_ on !policy. So there wasn't any sudden change in _that_
> piece of code, AFAIR.
>
>> The problem is that sometimes in the v3.12 kernel cycle we got a
>> BUG() crash instead of some random value back for calling early.
>>
>
> Yep, and that's most likely due to some change in ordering of calls somewhere,
> which makes calls to lock_policy_rwsem_read() before it is safe to do so,
> rather than anything related to how lock_policy_rwsem_read() handles the call.

I don't see any problem in the order things are called from both the places
where you got the crash from.. Because cpufreq driver is registered with
arch_initcall() and both the crash locations gets initialized after that..

I believe the problem is, cpufreq driver failed to register for some reason
and so we are getting this problem...

Can you please confirm if cpufreq driver failed to register or not?

And, I have another solution in mind for getting this problem fixed,
will get that to you by then..
