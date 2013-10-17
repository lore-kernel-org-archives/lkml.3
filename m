Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3JQJpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:45:31 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44610 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3JQJpa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 17 Oct 2013 05:45:30 -0400
Message-Id: <525FCDD702000078000FBBF5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 17 Oct 2013 10:45:27 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux@roeck-us.net>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify copy_from_user() checking
References: <525E964402000078000FB70C@nat28.tlf.novell.com>
 <525E9BF7.7020706@linux.intel.com>
 <525EC6C402000078000FB895@nat28.tlf.novell.com>
 <525EC73E.3060204@linux.intel.com>
In-Reply-To: <525EC73E.3060204@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.10.13 at 19:05, Arjan van de Ven <arjan@linux.intel.com> wrote:

>>> if you have found cases where this matters... maybe you found a new security
>>> issue...
>>
>> Iirc I could convince myself that in the cited cases the warnings
>> were there for no reason.
> 
> can you pick one on a source level ?
> (and the gcc 4.6 had a few false positives which is why it got disabled 
> there)

Sure: Let's take __tun_chr_ioctl(): While a static function, it gets
called with two different values for ifreq_len, both of which are
provably (for a human) correct. I don't think, however, that the
compiler can be expected to do so on its own in all cases - I would
expect it to be able to when it decides to inline the function in
both callers, but the larger that function grows, the more likely
it'll become that the compiler chooses to keep it separate (and it
surely would when CONFIG_CC_OPTIMIZE_FOR_SIZE).

Otoh one would expect a modern compiler to be able to do the
checking in the case of aer_inject_write(). Yet not everyone is
using most recent compiler versions, but I personally expect a
warning free compilation in that case too (at least outside the
staging sub-tree, which I avoid to build as much as possible). And
I know that I had seen the warning there (or else it wouldn't have
caught my attention, and I wouldn't have quoted it in the patch
description).

Jan

