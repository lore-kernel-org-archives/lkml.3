Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3KLKCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:02:37 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36260 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab3KLKCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:02:35 -0500
MIME-Version: 1.0
In-Reply-To: <8251B150E4DF5041A62C3EA9F0AB2E060255308A9E7D@SELDMBX99.corpusers.net>
References: <CAKfTPtCh+f1FZxkWqU5=2PjGtfRaN8jVV3WdTCzLDAWSjMP7yw@mail.gmail.com>
	<1383831224-26134-1-git-send-email-vincent.guittot@linaro.org>
	<8251B150E4DF5041A62C3EA9F0AB2E060255308A9E7B@SELDMBX99.corpusers.net>
	<CAKfTPtChCfWzyPUZt0VX5odMne79A+0wuzGOm+SK_pY2uKVA4A@mail.gmail.com>
	<8251B150E4DF5041A62C3EA9F0AB2E060255308A9E7D@SELDMBX99.corpusers.net>
Date: Tue, 12 Nov 2013 11:02:34 +0100
Message-ID: <CAKfTPtDkRbbVx2G+xd5qUXuo+Mt71vf7xSEVMhP-Gn1G-OuEmA@mail.gmail.com>
Subject: Re: Bench for testing scheduler
From: Vincent Guittot <vincent.guittot@linaro.org>
To: "Rowand, Frank" <Frank.Rowand@sonymobile.com>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Morten.Rasmussen@arm.com" <Morten.Rasmussen@arm.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pjt@google.com" <pjt@google.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, "mgorman@suse.de" <mgorman@suse.de>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "khilman@linaro.org" <khilman@linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2013 22:12, Rowand, Frank <Frank.Rowand@sonymobile.com> wrote:
>
> On Friday, November 08, 2013 1:28 AM, Vincent Guittot [vincent.guittot@linaro.org] wrote:
>>
>> On 8 November 2013 01:04, Rowand, Frank <Frank.Rowand@sonymobile.com> wrote:
>>
<snip>
>>
>> The Avg figures look almost stable IMO. Are you speaking about the Max
>> value for the inconsistency ?
>
> The values on my laptop for "-l 2000" are not stable.
>
> If I collapse all of the threads in each of the following tests to a
> single value I get the following table.  Note that each thread completes
> a different number of cycles, so I calculate the average as:
>
>   total count = T0_count + T1_count + T2_count + T3_count
>
>   avg = ( (T0_count * T0_avg) + (T1_count * T1_avg) + ... + (T3_count * T3_avg) ) / total count
>
>   min is the smallest min for any of the threads
>
>   max is the largest max for any of the threads
>
>             total
> test   T    count  min     avg   max
> ---- --- -------- ---- ------- -----
>    1   4     5886    2    76.0  1017
>    2   4     5881    2    71.5   810
>    3   4     5885    2    74.2  1143
>    4   4     5884    2    68.9  1279
>
> test 1 average is 10% larger than test 4.
>
> test 4 maximum is 50% larger than test2.
>
> But all of this is just a minor detail of how to run cyclictest.  The more
> important question is whether to use cyclictest results as a valid workload
> or metric, so for the moment I won't comment further on the cyclictest
> parameters you used to collect the example data you provided.
>
>
>>

<snip>

>> >
>
> Thanks for clarifying how the data was calculated (below).  Again, I don't think
> this level of detail is the most important issue at this point, but I'm going
> to comment on it while it is still fresh in my mind.
>
>> > Some questions about what these metrics are:
>> >
>> > The cyclictest data is reported per thread.  How did you combine the per thread data
>> > to get a single latency and stddev value?
>> >
>> > Is "Latency" the average latency?
>>
>> Yes. I have described below the procedure i have followed to get my results:
>>
>> I run the same test (same parameters) several times ( i have tried
>> between 5 and 10 runs and the results were similar).
>> For each run, i compute the average of per thread average figure and i
>> compute the stddev between per thread results.
>
> So the test run stddev is the standard deviation of the values for average
> latency of the 8 (???) cyclictest threads in a test run?

I have used 5 threads for my tests

>
> If so, I don't think that the calculated stddev has much actual meaning for
> comparing the algorithms (I do find it useful to get a loose sense of how
> consistent multiple test runs with the same parameters).
>
>> The results that i sent is an average of all runs with the same parameters.
>
> Then the stddev in the table is the average of the stddev in several test runs?

yes it is

>
> The stddev later on in the table is often in the range of 10%, 20%, 50%, and 100%
> of the average latency.  That is rather large.

yes i agree and it's an interesting figure IMHO because it points out
how the wake up of a core can impact the task scheduling latency and
how it's possible to reduce it or make it more stable (even if we
still have some large max value which are probably not linked to the
wake up of a core but other activities like deferable timer that have
fired

>
>>
>> >
>> > stddev is not reported by cyclictest.  How did you create this value?  Did you
>> > use the "-v" cyclictest option to report detailed data, then calculate stddev from
>> > the detailed data?
>>
>> No i haven't used the -v because it generates too much spurious wake
>> up that makes the results irrelevant
>
> Yes, I agree about not using -v.  It was just a wild guess on my part since
> I did not know how stddev was calculated.  And I was incorrectly guessing
> that stdev was describing the frequency distribution of the latencies
> from a single test run.

I haven't be so precise in my computation mainly because the output
were almost coherent but we probably need more precised statistic in a
final step

>
> As a general comment on cyclictest, I don't find average latency
> (in isolation) sufficient to compare different runs of cyclictest.
> And stddev of the frequency distribution of the latencies (which
> can be calculated from the -h data, with fairly low cyclictest
> overhead) is usually interesting but should be viewed with a healthy
> skepticism since that frequency distribution is often not a normal
> distribution.  In addition to average latency, I normally look at
> maximum latency and the frequency distribution of latence (in table
> or graph form).
>
> (One side effect of specifying -h is that the -d option is then
> ignored.)
>

I'm going to have a look at -h parameters which can be useful to get a
better view of the frequency distribution as you point out. Having the
distance set to 0 (-d) can be an issue because we could have a
synchronization of the wake up of the threads which will finally hide
the real wake up latency. It's interesting to have a distance which
ensures that the threads will wake up in an "asynchronous" manner
that's why i have chosen 150 (which is may be not the best value).

Thanks,
Vincent

> Thanks,
>
> -Frank
