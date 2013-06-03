Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab3FCQM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:12:27 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:52929 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756694Ab3FCQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:12:25 -0400
Message-ID: <51ACC066.1010902@semaphore.gr>
Date: Mon, 03 Jun 2013 19:12:22 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
References: <51A7BFA6.3070800@semaphore.gr> <CAKohpokGDFvtaBMKxLTJCkx_WN+HN4eZ7LZ2upBLsXAsmcq7kA@mail.gmail.com> <CAKohpo=EyudEW+EX=b7=Wp-7ceqjVksDTwwSJf77_LNFaaNL3w@mail.gmail.com> <2413427.Abjbfkms0Z@vostro.rjw.lan> <CAKohpomLkogSHD+5Wobb34qHPnb7_vWE1Xz4K5MD=Q50kOpfuA@mail.gmail.com>
In-Reply-To: <CAKohpomLkogSHD+5Wobb34qHPnb7_vWE1Xz4K5MD=Q50kOpfuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 02:24 PM, Viresh Kumar wrote:
> On 3 June 2013 16:27, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> The question is if we want policy->max to re-scale them effectively (i.e. to
>> change weights so that the maximum load maps to the highest frequency available
>> at the moment) or if we want policy->max to work as a cap (i.e. to map all
>> loads above certain value to the maximum frequency available at the moment, so
>> that the criteria for selecting the lower frequencies don't change).  In my
>> opinion the second option is better, because it means "OK, we can't use some
>> high frequencies, but let's not hurt performance for the loads that wouldn't
>> require them anyway".  Otherwise, we'll effectively throttle all loads and
>> that not only causes performance to drop, but also causes more energy to be
>> used overall.
> 
> I wouldn't say that I don't agree with you as I do to some extent.
> 
> But the question that comes to my mind now is: Why is policy->max reduced
> in the first place? User doesn't have control over which freqs to expose, so
> available_frequencies will stay the same. The only thing he is capable
> of doing is: reduce policy->max.. Which in a way means that.. "I don't want to
> use higher frequencies (power, thermal reasons) and I know performance will
> go down with it and I don't care for it now."
> 
> And this way I feel policy->max isn't a bad choice either.
> 
> BUT as you said: policy->max isn't there to say don't be so aggressive now in
> increasing frequencies but just only to say, don't go over this frequency..
> 
> So, probably we can use cpuinfo.max_freq :)
> 

Both of you know better than me, but I also believe that cpuinfo.max is more
appropriate. Although, the decision was taken, let me share a spreadsheet to show
the 2 cases.
https://docs.google.com/spreadsheet/ccc?key=0AnMfNYUV1k0ddHh1OUFXa0kxcGZJaXd4am1sdmVWT0E&usp=sharing

I will prepare the v2 of this patch that uses cpuinfo.max_freq instead of policy-max.
Also, I will split the patch into 3 parts as suggested.


Thank you for your comments and suggestions!
Stratos
