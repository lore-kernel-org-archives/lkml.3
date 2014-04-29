Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbaD2KAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:00:05 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45804 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaD2KAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:00:02 -0400
Message-ID: <535F77E8.2040000@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 15:29:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>, Hugh Dickins <hughd@google.com>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
References: <535EA976.1080402@linux.vnet.ibm.com> <CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com> <CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com> <alpine.LSU.2.11.1404281500180.2861@eggly.anvils> <1398723290.25549.20.camel@buesod1.americas.hpqcorp.net> <CA+55aFwGjYS7PqsD6A-q+Yp9YZmiM6mB4MUYmfR7ro02poxxCQ@mail.gmail.com>
In-Reply-To: <CA+55aFwGjYS7PqsD6A-q+Yp9YZmiM6mB4MUYmfR7ro02poxxCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042909-1396-0000-0000-000004C19D1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 03:55 AM, Linus Torvalds wrote:
> On Mon, Apr 28, 2014 at 3:14 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>>
>> I think that returning some stale/bogus vma is causing those segfaults
>> in udev. It shouldn't occur in a normal scenario. What puzzles me is
>> that it's not always reproducible. This makes me wonder what else is
>> going on...
> 
> I've replaced the BUG_ON() with a WARN_ON_ONCE(), and made it be
> unconditional (so you don't have to trigger the range check).
> 
> That might make it show up earlier and easier (and hopefully closer to
> the place that causes it). Maybe that makes it easier for Srivatsa to
> reproduce this. It doesn't make *my* machine do anything different,
> though.
> 
> Srivatsa? It's in current -git.
> 

I tried this, but still nothing so far. I rebooted 10-20 times, and also
tried multiple runs of multi-threaded ebizzy and kernel compilations,
but none of this hit the warning.

Is there anything more specific I can run to increase the chances of
hitting this? I guess a test-case might be too much to ask since I'm
the first one hitting this, but if anybody has suggestions of scenarios
which have a higher likelihood of hitting this (like running multi-
threaded workloads or whatever), I could probably give it a try as well.

Thank you!

Regards,
Srivatsa S. Bhat

