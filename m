Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3FYPIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:08:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43072 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab3FYPIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:08:16 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130625073819.GC11420@gmail.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <1371831934-156971-3-git-send-email-nzimmer@sgi.com> <20130623092840.GB13445@gmail.com> <20130624203657.GA107621@asylum.americas.sgi.com> <20130625073819.GC11420@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 25 Jun 2013 08:07:42 -0700
To: Ingo Molnar <mingo@kernel.org>, Nathan Zimmer <nzimmer@sgi.com>
CC: holt@sgi.com, travis@sgi.com, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <58029951-199f-484d-ad60-199d15a89c12@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have to say I really like this concept. It should have some very nice properties including perhaps making THP work better?

Ingo Molnar <mingo@kernel.org> wrote:

>
>* Nathan Zimmer <nzimmer@sgi.com> wrote:
>
>> On Sun, Jun 23, 2013 at 11:28:40AM +0200, Ingo Molnar wrote:
>> > 
>> > That's 4.5 GB/sec initialization speed - that feels a bit slow and
>the 
>> > boot time effect should be felt on smaller 'a couple of gigabytes' 
>> > desktop boxes as well. Do we know exactly where the 2 hours of boot
>
>> > time on a 32 TB system is spent?
>> 
>> There are other several spots that could be improved on a large
>system 
>> but memory initialization is by far the biggest.
>
>My feeling is that deferred/on-demand initialization triggered from the
>
>buddy allocator is the better long term solution.
>
>That will also make it much easier to profile/test memory init 
>performance: boot up a large system and run a simple testprogram that 
>allocates a lot of RAM.
>
>( It will also make people want to optimize the initialization sequence
>
>  better, as it will be part of any freshly booted system's memory 
>  allocation overhead. )
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
