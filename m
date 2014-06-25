Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaFYDY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 23:24:58 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:31693 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbaFYDY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 23:24:57 -0400
Message-ID: <53AA4108.6090302@akamai.com>
Date: Tue, 24 Jun 2014 22:24:56 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Baron, Jason" <jbaron@akamai.com>
Subject: Re: [PATCH] panic: add TAINT_SOFTLOCKUP
References: <1401847955-3345-1-git-send-email-johunt@akamai.com> <20140623151121.44f17779004e94ab620b837c@linux-foundation.org> <53A8ADEC.6070406@akamai.com> <20140623155118.e2446a6110a9889454db2386@linux-foundation.org> <53A9899C.9040005@akamai.com> <alpine.DEB.2.02.1406241740330.22030@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406241740330.22030@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 07:45 PM, David Rientjes wrote:
> On Tue, 24 Jun 2014, Josh Hunt wrote:
>
>> Anyone you'd suggest adding to this thread to get other feedback about
>> tracking page allocation failures? I could also spin up a patch and cc them.
>>
>
> Page allocation failures happen all the time, mostly because of
> large-order allocations (more than PAGE_ALLOC_COSTLY_ORDER) or allocations
> done with GFP_ATOMIC where it's impossible to reclaim or compact memory to
> allocate.  Because of this, they are fairly easy to trigger from userspace
> without having to do much.
>
> Why would this qualify for a taint?  I have never debugged a kernel crash
> that I traced back to an earlier page allocation failure and said "oh, if
> I had only known about that page allocation failure earlier!".  If one of
> them is going to cause an issue, it probably is at the point of the crash
> and you shouldn't have to "investigate" much.
>

I guess I was thinking more of the case where all you have is the 
trace/dump and for whatever reason the last bits which may contain the 
page allocation failure info didn't get flushed to disk. In that case 
it'd be nice to know what lead up to the crash. However, I do agree with 
your point and Andrew's about the frequency and ease of triggering them 
which would make taint the wrong place to account for them.

Thanks
Josh


