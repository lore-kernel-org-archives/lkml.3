Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaKIWH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 17:07:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaKIWHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 17:07:25 -0500
Message-ID: <545FE59B.3020702@suse.cz>
Date: Sun, 09 Nov 2014 23:07:23 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: AL13N <alien@rmail.be>, linux-kernel@vger.kernel.org
Subject: Re: Memory leaks on atom-based boards?
References: <8bdeb6866adef7f2d34a693040c33f12.squirrel@mail.rmail.be>    <545F566F.7010102@suse.cz> <27d4dc6a448169861446f8c1b3c3cadd.squirrel@mail.rmail.be>
In-Reply-To: <27d4dc6a448169861446f8c1b3c3cadd.squirrel@mail.rmail.be>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 05:38 PM, AL13N wrote:
>> On 10/27/2014 07:44 PM, AL13N wrote:
>>
>> Hi, this does look like a kernel memory leak. There was recently a known
>> one fixed by patch from https://lkml.org/lkml/2014/10/15/447 which made
>> it to 3.18-rc3 and should be backported to stable kernels 3.8+ soon.
>> You would recognize if this is the fix for you by checking the
>> thp_zero_page_alloc value in /proc/vmstat. Value X > 1 basically means
>> that X*2 MB memory is leaked.
>> You say in the serverfault post that 3.17.2 helped, but the fix is not
>> in 3.17.2... but it could be just that the circumstances changed and THP
>> zero pages are no longer freed and realocated.
>> So if you want to be sure, I would suggest trying again a version where
>> the problem appeared on your system, and checking the
>> thp_zero_page_alloc. Perhaps you'll see a >1 value even on 3.17.2, which
>> means some leak did occur there as well, but maybe not so severe.
> 
> 
> i was gonna tell you guys, but i was waiting until i was sure, but indeed
> 3.17.2 fixed, it, where i had OOM after 3, maybe 4 days (for at least 2
> months), now i'm up more than 4 days and the MemAvailable is still high
> enough... at about 3.5GB whereas otherwise it would dwindle until 0. (at
> about 1GB/day)
> 
> Well, it results to 0 on 3.17.2 ... so... i guess not? i'll keep this
> value under observation...

Hm, 0 sounds like nobody was allocating transparent huge pages at all. What
about the other thp_* stats?

>>>  - How can i find out what is allocating all this memory?
>>
>> There's no simple way, unfortunately. Checking the kpageflags /proc file
>> might help. IIRC there used to be a patch in -mm tree to store who
>> allocated what page, but it might be bitrotten.
> 
> 
> i checked what was in kpageflags (or kpagecount) but it's all some kind of
> binary stuff...
> 
> do i need some tool to interprete these values?

There's tools/vm/page-types.c in kernel sources which can read kpageflags, but
not the kpagecount...

Vlastimil
