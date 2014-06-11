Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaFKQsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:48:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:52780 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaFKQso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:48:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,459,1400050800"; 
   d="scan'208";a="526926651"
Message-ID: <5398885F.10206@linux.intel.com>
Date: Wed, 11 Jun 2014 09:48:31 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
Subject: Re: drivers/char/random.c: More futzing about
References: <20140609013553.GA1167@thunk.org> <20140609131738.13625.qmail@ns.horizon.com> <20140611163818.GD27151@thunk.org>
In-Reply-To: <20140611163818.GD27151@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 09:38 AM, Theodore Ts'o wrote:
> On Mon, Jun 09, 2014 at 09:17:38AM -0400, George Spelvin wrote:
>> Here's an example of a smaller, faster, and better fast_mix() function.
>> The mix is invertible (thus preserving entropy), but causes each input
>> bit or pair of bits to avalanche to at least 43 bits after 2 rounds and
>> 120 bit0 after 3.
> 
> I've been looking at your fast_mix2(), and it does look interesting.
> 
>> For comparison, with the current linear fast_mix function, bits above
>> the 12th in the data words only affect 4 other bits after one repetition.
>>
>> With 3 iterations, it runs in 2/3 the time of the current fast_mix
>> and is half the size: 84 bytes of object code as opposed to 168.
> 
> ... but how did you measure the "2/3 the time"?  I've done some
> measurements, using both "time calling fast_mix() and fast_mix2() N
> times and divide by N (where N needs to be quite large).  Using that
> metric, fast_mix2() takes seven times as long to run.
> 
> If I only run the two mixing functions once, and use RDTSC to measure
> the time, fast_mix2() takes only three times as long.  (That's because
> the memory cache effects are much less, which favors fast_mix2).
> 
> But either way, fast_mix2() is slower than the current fast_mix(), and
> using the measurements that are as advantageous (and most realistic)
> that I could come up with, it's still three times slower.
> 
> My measurements were done using Intel 2.8 GHz quad-core i7-4900MQ CPU.
> 

While talking about performance, I did a quick prototype of random using
Skein instead of SHA-1, and it was measurably faster, in part because
Skein produces more output per hash.

	-hpa


