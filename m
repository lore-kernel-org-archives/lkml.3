Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab3JQPxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:53:32 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41663 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab3JQPxb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 17 Oct 2013 11:53:31 -0400
Message-Id: <5260241602000078000FBDD9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 17 Oct 2013 16:53:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux@roeck-us.net>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify copy_from_user() checking
References: <525E964402000078000FB70C@nat28.tlf.novell.com>
 <525E9BF7.7020706@linux.intel.com>
 <525EC6C402000078000FB895@nat28.tlf.novell.com>
 <525EC73E.3060204@linux.intel.com>
 <525FCDD702000078000FBBF5@nat28.tlf.novell.com>
 <52600608.2010704@linux.intel.com>
In-Reply-To: <52600608.2010704@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.10.13 at 17:45, Arjan van de Ven <arjan@linux.intel.com> wrote:
> for me, the value of the feature overall is this range checking, not the 
> fixed size part.
> for fixed size... the chance of the programmer getting it wrong is near 
> zero.
> the chance of getting one of the checks wrong is much higher
> (we've had cases of wrong sign in the checks, off by ones in the checks etc)
> and that is what it was supposed to find.
> If that's not possible due practical issues (like the inline case above but 
> more
> the compiler practicalities).... removing the warning part entirely is 
> likely just better.

But it would at least cover the case where, for some pointer,
someone mixes up sizeof(ptr) and sizeof(*ptr). So I think - it
being cheap - the current constant size check could stay, ...

> Having a runtime check for the case where the argument is not constant but 
> we know the buffer
> size... is likely still clear value... cheap (perfect branch prediction 
> unless disaster hits!)
> and the failure case is obviously the disaster case.

... and the non-constant case be taken care of at run time.
That's precisely what the patch does.

Jan

