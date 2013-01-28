Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3A1P10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:27:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3A1P1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:27:23 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <51064D3B02000078000B9EE8@nat28.tlf.novell.com>
References: <5093E4F302000078000A6162@nat28.tlf.novell.com> <tip-05fbf4d6fc6a3c0c3e63b77979c9311596716d10@git.kernel.org> <510302FD.3090009@zytor.com> <51064D3B02000078000B9EE8@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/asm] x86/xor: Make virtualization friendly
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2013 07:26:59 -0800
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Message-ID: <afc57813-b94d-4dfd-a45d-96204edac1e9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It adds substantial boot time, and it has no value when the cache priority rules force the non-cache-polluting version even if somewhat slower... which can and does happen.

Jan Beulich <JBeulich@suse.com> wrote:

>>>> On 25.01.13 at 23:11, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> On 01/25/2013 02:43 AM, tip-bot for Jan Beulich wrote:
>>> Commit-ID:  05fbf4d6fc6a3c0c3e63b77979c9311596716d10
>>> Gitweb:     
>> http://git.kernel.org/tip/05fbf4d6fc6a3c0c3e63b77979c9311596716d10 
>>> Author:     Jan Beulich <JBeulich@suse.com>
>>> AuthorDate: Fri, 2 Nov 2012 14:21:23 +0000
>>> Committer:  Ingo Molnar <mingo@kernel.org>
>>> CommitDate: Fri, 25 Jan 2013 09:23:51 +0100
>>> 
>>> x86/xor: Make virtualization friendly
>>> 
>>> In virtualized environments, the CR0.TS management needed here
>>> can be a lot slower than anticipated by the original authors of
>>> this code, which particularly means that in such cases forcing
>>> the use of SSE- (or MMX-) based implementations is not desirable
>>> - actual measurements should always be done in that case.
>>> 
>>> For consistency, pull into the shared (32- and 64-bit) header
>>> not only the inclusion of the generic code, but also that of the
>>> AVX variants.
>>> 
>> 
>> This patch is wrong and should be dropped.  I verified it with the
>KVM
>> people that they do NOT want this change.  It is a Xen-specific
>problem.
>
>I don't follow: The patch doesn't penalize anyone, it merely
>widens the set of methods tried on virtualized platforms. I.e.
>if other hypervisors have no problem here, then the best
>performing one should still turn out to be the SSE or AVX one.
>Or if it doesn't, it ought to be to their advantage (I would even
>question why this extra probing isn't done on native too, e.g.
>to cope with eventual bad vector implementations, say on
>low-power/low-cost CPUs).
>
>Jan

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
