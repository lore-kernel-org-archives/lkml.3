Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaFYDjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 23:39:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55564 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaFYDjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 23:39:13 -0400
MIME-Version: 1.0
In-Reply-To: <53AA4108.6090302@akamai.com>
References: <1401847955-3345-1-git-send-email-johunt@akamai.com>
	<20140623151121.44f17779004e94ab620b837c@linux-foundation.org>
	<53A8ADEC.6070406@akamai.com>
	<20140623155118.e2446a6110a9889454db2386@linux-foundation.org>
	<53A9899C.9040005@akamai.com>
	<alpine.DEB.2.02.1406241740330.22030@chino.kir.corp.google.com>
	<53AA4108.6090302@akamai.com>
Date: Tue, 24 Jun 2014 23:39:12 -0400
Message-ID: <CAPDOMVienF9gj8fAeqdXQRM9+v3jpFRygA1aL4DqiEU2dbH5tA@mail.gmail.com>
Subject: Re: [PATCH] panic: add TAINT_SOFTLOCKUP
From: Nick Krause <xerofoify@gmail.com>
To: Josh Hunt <johunt@akamai.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Baron, Jason" <jbaron@akamai.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you want to flush the ram issues back to disk,
that may be a good idea otherwise I would just
close this discussion.
Cheers Nick

On Tue, Jun 24, 2014 at 11:24 PM, Josh Hunt <johunt@akamai.com> wrote:
> On 06/24/2014 07:45 PM, David Rientjes wrote:
>>
>> On Tue, 24 Jun 2014, Josh Hunt wrote:
>>
>>> Anyone you'd suggest adding to this thread to get other feedback about
>>> tracking page allocation failures? I could also spin up a patch and cc
>>> them.
>>>
>>
>> Page allocation failures happen all the time, mostly because of
>> large-order allocations (more than PAGE_ALLOC_COSTLY_ORDER) or allocations
>> done with GFP_ATOMIC where it's impossible to reclaim or compact memory to
>> allocate.  Because of this, they are fairly easy to trigger from userspace
>> without having to do much.
>>
>> Why would this qualify for a taint?  I have never debugged a kernel crash
>> that I traced back to an earlier page allocation failure and said "oh, if
>> I had only known about that page allocation failure earlier!".  If one of
>> them is going to cause an issue, it probably is at the point of the crash
>> and you shouldn't have to "investigate" much.
>>
>
> I guess I was thinking more of the case where all you have is the trace/dump
> and for whatever reason the last bits which may contain the page allocation
> failure info didn't get flushed to disk. In that case it'd be nice to know
> what lead up to the crash. However, I do agree with your point and Andrew's
> about the frequency and ease of triggering them which would make taint the
> wrong place to account for them.
>
> Thanks
> Josh
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
