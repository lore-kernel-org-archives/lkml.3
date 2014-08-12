Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaHLRiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:38:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaHLRiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:38:10 -0400
Message-ID: <53EA50FE.8060103@nod.at>
Date: Tue, 12 Aug 2014 19:38:06 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walter <sahne@0x90.at>,
        =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] resource: Fix the case of null pointer access
References: <20140812144655.GB16961@redhat.com> <53EA297F.1040107@nod.at> <20140812150417.GC16961@redhat.com>
In-Reply-To: <20140812150417.GC16961@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.08.2014 17:04, schrieb Vivek Goyal:
> On Tue, Aug 12, 2014 at 04:49:35PM +0200, Richard Weinberger wrote:
>> Am 12.08.2014 16:46, schrieb Vivek Goyal:
>>> Richard and Daniel reported that UML is broken due to changes to resource
>>> traversal functions. Problem is that iomem_resource.child can be null
>>> and new code does not consider that possibility. Old code used a for loop
>>> and that loop will not even execute if p was null.
>>>
>>> Revert back to for() loop logic and bail out if p is null.
>>>
>>> I also moved sibling_only check out of resource_lock. There is no
>>> reason to keep it inside the lock.
>>>
>>> Following is backtrace of the UML crash.
>>
>> Shall I pickup this patch and route it via my uml tree to Linus?
> 
> I am fine with that. 

Whoops, I oversaw that your patch does not touch anything in arch/um/.
It is not UML specific. Let's see what Andrew says.

Thanks,
//richard
