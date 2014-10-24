Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaJXPFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:05:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25201 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaJXPFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:05:12 -0400
Message-ID: <544A6A6B.3040602@oracle.com>
Date: Fri, 24 Oct 2014 11:04:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, Daniel Borkmann <dborkman@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        x86@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com> <5444EBFA.5030103@samsung.com> <20141020124929.GA23177@thunk.org> <54451501.2070700@samsung.com> <5445179A.4080804@redhat.com> <20141020141635.GA4499@thunk.org> <20141024100108.GF12706@worktop.programming.kicks-ass.net> <544A52D7.6000202@oracle.com> <20141024134205.GB21513@worktop.programming.kicks-ass.net>
In-Reply-To: <20141024134205.GB21513@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 09:42 AM, Peter Zijlstra wrote:
> On Fri, Oct 24, 2014 at 09:23:35AM -0400, Sasha Levin wrote:
>>
>> i >> 32 may happen to be "i", but is there anything that prevents the compiler
>> from returning, let's say, 42?
> 
> Not really, although gcc seems to opt for the 'sane' option and emit the
> instruction and let the arch figure out how to deal with it. Hence the
> 'fun' difference between x86 and ARM.

It's interesting how many different views on undefined behaviour there are between
kernel folks.

Everything between Ted Ts'o saying that GCC can launch nethack on oversized shifts,
to DaveM saying he will file a GCC bug if the behaviour isn't sane w.r.t to memcpy().


Thanks,
Sasha
