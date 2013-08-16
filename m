Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3HPQxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:53:14 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753205Ab3HPQxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:53:11 -0400
Message-ID: <520E58F3.4080309@nod.at>
Date: Fri, 16 Aug 2013 18:53:07 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] print_worker_info: Handle pointer with more care
References: <1376668606-32354-1-git-send-email-richard@nod.at> <20130816161229.GI2505@htj.dyndns.org> <520E500B.5000408@nod.at> <20130816162844.GJ2505@htj.dyndns.org> <520E55A2.9080900@nod.at> <20130816164544.GK2505@htj.dyndns.org>
In-Reply-To: <20130816164544.GK2505@htj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.08.2013 18:45, schrieb Tejun Heo:
> Hello,
> 
> On Fri, Aug 16, 2013 at 06:38:58PM +0200, Richard Weinberger wrote:
>>> cc'ing uml people.  Hey, guys, workqueue uses proble_kernel_read() to
>>> print out workqueue related information during oops because those
>>> events are completely asynchronous and workqueue states may not be
>>> consistently accessible.  It seems like uml doesn't implement
>>> probe_kernel_read() and tries direct derference of incorrect pointers
>>> leading to its own oops.  Maybe uml should check whether the memory is
>>> mapped from probe_kernel_read()?
>>
>> You are already talking to UML people. ;)
> 
> Ooh... :)
> 
>> Anyway, I'll investigate into that.
>> What I see so far is that pwq is NULL after probe_kernel_read().
> 
> Yeah, and that should be fine.  &pwq->wq would be just an offset of wq

Yep. Now my brain also parsed the C notation correctly.
Sorry for the completely wrong patch.

> from NULL which is an invalid pointer but probe_kernel_read() should
> be able to handle that and probably just return 0 or -1 (all bits
> set).  I *think* what's necessary is making probe_kernel_read() use
> mincore() to fine out whether the requested address is mapped (it
> should return -EFAULT if not) and try to dereference the address iff
> it's mapped.

UML needs a custom probe_kernel_read()? Fine. :)

Thanks,
//richard

