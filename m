Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3A1JF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:05:29 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:50865 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3A1JEt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 28 Jan 2013 04:04:49 -0500
Message-Id: <51064D3B02000078000B9EE8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 28 Jan 2013 09:04:43 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@kernel.org>, <tglx@linutronix.de>, <torvalds@linux-foundation.org>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/asm] x86/xor: Make virtualization friendly
References: <5093E4F302000078000A6162@nat28.tlf.novell.com>
 <tip-05fbf4d6fc6a3c0c3e63b77979c9311596716d10@git.kernel.org>
 <510302FD.3090009@zytor.com>
In-Reply-To: <510302FD.3090009@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.01.13 at 23:11, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 01/25/2013 02:43 AM, tip-bot for Jan Beulich wrote:
>> Commit-ID:  05fbf4d6fc6a3c0c3e63b77979c9311596716d10
>> Gitweb:     
> http://git.kernel.org/tip/05fbf4d6fc6a3c0c3e63b77979c9311596716d10 
>> Author:     Jan Beulich <JBeulich@suse.com>
>> AuthorDate: Fri, 2 Nov 2012 14:21:23 +0000
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Fri, 25 Jan 2013 09:23:51 +0100
>> 
>> x86/xor: Make virtualization friendly
>> 
>> In virtualized environments, the CR0.TS management needed here
>> can be a lot slower than anticipated by the original authors of
>> this code, which particularly means that in such cases forcing
>> the use of SSE- (or MMX-) based implementations is not desirable
>> - actual measurements should always be done in that case.
>> 
>> For consistency, pull into the shared (32- and 64-bit) header
>> not only the inclusion of the generic code, but also that of the
>> AVX variants.
>> 
> 
> This patch is wrong and should be dropped.  I verified it with the KVM
> people that they do NOT want this change.  It is a Xen-specific problem.

I don't follow: The patch doesn't penalize anyone, it merely
widens the set of methods tried on virtualized platforms. I.e.
if other hypervisors have no problem here, then the best
performing one should still turn out to be the SSE or AVX one.
Or if it doesn't, it ought to be to their advantage (I would even
question why this extra probing isn't done on native too, e.g.
to cope with eventual bad vector implementations, say on
low-power/low-cost CPUs).

Jan

