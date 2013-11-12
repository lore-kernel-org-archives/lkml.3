Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3KLSsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:48:47 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:39059 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3KLSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:48:45 -0500
Message-ID: <528276F4.7020009@linux.vnet.ibm.com>
Date: Wed, 13 Nov 2013 00:14:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl,
        gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        amit.kachhap@linaro.org, thomas.abraham@linaro.org,
        markgross@thegnar.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <52437128.7030402@linux.vnet.ibm.com> <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org> <52442F6F.5020703@linux.vnet.ibm.com> <5281E09B.3060303@linux.vnet.ibm.com> <528266A9.2040901@sr71.net>
In-Reply-To: <528266A9.2040901@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111218-8878-0000-0000-000009A8A5FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 11:04 PM, Dave Hansen wrote:
> On 11/12/2013 12:02 AM, Srivatsa S. Bhat wrote:
>> I performed experiments on an IBM POWER 7 machine and got actual power-savings
>> numbers (upto 2.6% of total system power) from this patchset. I presented them
>> at the Kernel Summit but forgot to post them on LKML. So here they are:
> 
> "upto"?  What was it, actually?

Hmm? It _was_ 2.6% (Maybe my usage of the word 'upto' is misleading in that
sentence, sorry).

>  Essentially what you've told us here is
> that you have a patch that tries to do some memory power management and
> that it accomplishes that.  But, to what degree?
> 
> Was your baseline against a kernel also booted with numa=fake=1, or was
> it a kernel booted normally?
> 

The baseline kernel was also booted with numa=fake=1.

> 1. What is the theoretical power savings from memory?

I don't have that number for POWER (but I'll work on that), but referring to
the previous data from Samsung ARM boards, it was around the same number
(2.7% to 3.2 % of total system power) for memory power management using
content-preserving states. For content-destructive (power-off) states, it was
around 6.3%.

http://article.gmane.org/gmane.linux.kernel.mm/65935

> 2. How much of the theoretical numbers can your patch reach?

Honestly, the 2.6% number on the hardware that I tested is not bad at all.
As I mentioned, the base power consumption of the system (power consumption
at idle) was a bit high, so the percentage power-savings value might look small,
but nevertheless it is not insignificant. I'm trying to setup a newer prototype
hardware to test this patchset, and I expect to see better numbers on that
with the same code. By some crude initial estimates, I expect to see around
5% power-savings with the same patchset.

> 3. What is the performance impact?  Does it hurt ebizzy?
> 

Ebizzy numbers were quite low in both cases (vanilla and patched kernel),
in 1 digit numbers, due to the huge allocations/frees that were done on every
loop. So comparing performance with those numbers is not going to be reliable.
I'll work on detailed performance measurements after I'm done with the initial
power-savings experiments.

> You also said before:
>> On page 40, the paper shows the power-consumption breakdown for an IBM p670
>> machine, which shows that as much as 40% of the system energy is consumed by
>> the memory sub-system in a mid-range server.
> 
> 2.6% seems pretty awful for such an invasive patch set if you were
> expecting 40%.

As I said, this was not the most ideal hardware to test my patches on. 128GB
is not a particularly large amount of RAM. So obviously it wont contribute a
whole lot to the total system power, atleast not as much as, say a terabyte of
RAM would. So yeah, the overall number is small, but given the relatively
modest amount of RAM installed on that machine, the savings is not ignorable.

Also, I used only 4 memory regions on this hardware, which is quite a small
number to play with. More the number of memory regions, higher the opportunity
that my patches have to cause power-savings. So I'll test with newer platforms
(with more memory regions) to see how well that goes.

Regards,
Srivatsa S. Bhat

