Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaICSi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 14:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaICSi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 14:38:58 -0400
Message-ID: <54076022.80202@redhat.com>
Date: Wed, 03 Sep 2014 14:38:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrew Theurer <atheurer@redhat.com>
CC: linux-kernel@vger.kernel.org, oleg@redhat.com, peterz@infradead.org,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/3] lockless sys_times and posix_cpu_clock_get
References: <1408133138-22048-1-git-send-email-riel@redhat.com> <198309898.21797553.1408483311099.JavaMail.zimbra@redhat.com>
In-Reply-To: <198309898.21797553.1408483311099.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/19/2014 05:21 PM, Andrew Theurer wrote:
> 
>> Thanks to the feedback from Oleg, Peter, Mike, and Frederic, I
>> seem to have a patch series that manages to do times() 
>> locklessly, and apparently correctly.
> 
> 
>> 
>> Oleg points out that the monotonicity alone is not enough of a 
>> guarantee, but that should probably be attacked separately,
>> since that issue is equally present with and without these
>> patches...
>> 
>> The test case below, slightly changed from the one posted by
>> Spencer Candland in 2009, now runs in 11 seconds instead of 5
>> minutes.
>> 
>> Is it worthwhile?  There apparently are some real workloads that
>> call times() a lot, and I believe Sanjay and Andrew have one
>> sitting around.
> 
> Thanks for doing this.  When running a OLTP workload in a KVM VM,
> we saw a 71% increase in performance!  do_sys_times() was a big
> bottleneck for us.

Thanks Andrew, a 71% performance increase seems like it would be
enough to justify merging these patches...


Peter, Ingo, Andrew,

Do any of you have an objection to these patches?

Which tree should I merge them through?

I am happy to resubmit them against any tree, just let
me know where you want the patches to go.

thanks,

Rik
- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUB2AiAAoJEM553pKExN6DlKsH/RygM0SAcKcqbhk7qbKgQsFI
fe9mzJeDg5X2OVW1LuKKhpdo0wPiJ6arg3s2kWnJ8YuToMlIYjFwh9V+fwk1p7bV
4X8KYEK1DyJux8ZYwOBXlZORL+mE30scwuOF8B0sY+TepiRHeorv0srTIXgJfGyJ
avv95X/hx5JSqjAeRomHPmIX8VzgbHTXPEzWxVj+64qehI63CqyLGXXSlHPvFL4D
uhIRvCC4WxKNldUX20HZFUlQETsJttWoM14SiT1HZbfZNJxDMkD6kjcNl7Uimw9j
gVQeE4qy5OkdY1RSsVN35mg+mGA8kzUoQV0aEkogXwbJYNB+wFQ7OEupA1BKiGw=
=6lUC
-----END PGP SIGNATURE-----
