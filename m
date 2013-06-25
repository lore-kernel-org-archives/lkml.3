Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab3FYSwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:52:06 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55022 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751490Ab3FYSwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:52:04 -0400
Message-ID: <51C9E6CD.5080508@sgi.com>
Date: Tue, 25 Jun 2013 11:51:57 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>, Nathan Zimmer <nzimmer@sgi.com>,
        holt@sgi.com, rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <1371831934-156971-3-git-send-email-nzimmer@sgi.com> <20130623092840.GB13445@gmail.com> <20130624203657.GA107621@asylum.americas.sgi.com> <20130625073819.GC11420@gmail.com> <51C9D1D6.20405@sgi.com> <51C9E4B7.2000007@zytor.com>
In-Reply-To: <51C9E4B7.2000007@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/25/2013 11:43 AM, H. Peter Anvin wrote:
> On 06/25/2013 10:22 AM, Mike Travis wrote:
>>
>> On 6/25/2013 12:38 AM, Ingo Molnar wrote:
>>>
>>> * Nathan Zimmer <nzimmer@sgi.com> wrote:
>>>
>>>> On Sun, Jun 23, 2013 at 11:28:40AM +0200, Ingo Molnar wrote:
>>>>>
>>>>> That's 4.5 GB/sec initialization speed - that feels a bit slow and the 
>>>>> boot time effect should be felt on smaller 'a couple of gigabytes' 
>>>>> desktop boxes as well. Do we know exactly where the 2 hours of boot 
>>>>> time on a 32 TB system is spent?
>>>>
>>>> There are other several spots that could be improved on a large system 
>>>> but memory initialization is by far the biggest.
>>>
>>> My feeling is that deferred/on-demand initialization triggered from the 
>>> buddy allocator is the better long term solution.
>>
>> I haven't caught up with all of Nathan's changes yet (just
>> got back from vacation), but there was an option to either
>> start the memory insertion on boot, or trigger it later
>> using the /sys/.../memory interface.  There is also a monitor
>> program that calculates the memory insertion rate.  This was
>> extremely useful to determine how changes in the kernel
>> affected the rate.
>>
> 
> Sorry, I *totally* did not follow that comment.  It seemed like a
> complete non-sequitur?
> 
> 	-hpa

It was I who was not following the question.  I'm still reverting
back to "work mode".

[There is more code in a separate patch that Nate has not sent
yet that instructs the kernel to start adding memory as early
as possible, or not.  That way you can start the insertion process
later and monitor it's progress to determine how changes in the
kernel affect that process.  It is controlled by a separate
CONFIG option.]


> 
> 
