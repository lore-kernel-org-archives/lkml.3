Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3J3Fde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:33:34 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50203 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3J3Fdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:33:33 -0400
Message-ID: <52709A23.9060204@linux.vnet.ibm.com>
Date: Wed, 30 Oct 2013 11:03:23 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>, mmarek@suse.cz,
        akpm@linux-foundation.org
Subject: Re: [PATCH] scripts/kconfig/menu.c: warning: jump may be used uninitialized
 in this function
References: <alpine.DEB.2.11.1310271822540.31521@trent.utfs.org> <alpine.DEB.2.11.1310271859320.31521@trent.utfs.org> <20131029175354.GB3411@free.fr>
In-Reply-To: <20131029175354.GB3411@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103005-9264-0000-0000-000004D34069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 October 2013 11:23 PM, Yann E. MORIN wrote:
> Christian, All,
> 
> On 2013-10-27 19:02 -0700, Christian Kujau spake thusly:
>> On Sun, 27 Oct 2013 at 18:28, Christian Kujau wrote:
>>> While doing "make oldconfig" on 3.12-rc7 with gcc-4.7.2 (Debian), the 
>>> following warning is printed:
>>>
>>>   HOSTCC  scripts/kconfig/zconf.tab.o
>>> In file included from scripts/kconfig/zconf.tab.c:2537:0:
>>> /usr/local/src/linux-git/scripts/kconfig/menu.c: In function ‘get_symbol_str’:
>>> /usr/local/src/linux-git/scripts/kconfig/menu.c:586:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>> /usr/local/src/linux-git/scripts/kconfig/menu.c:547:19: note: ‘jump’ was declared here
>>
>> Grrr, only after I sent this message I found this was reported in 
>> September already by Madhavan Srinivasan:  https://lkml.org/lkml/2013/9/19/24
>>
>> Does anybody know the state of this fix?
> 
My bad, somehow this slipped from my todo list.

> The solution was to properly comment that this was a gcc issue, in that 
> this is a spurious error, does not appear in previous gcc versions, and
> has been fixed in later gcc versions.
> 
I also notice this with gcc 4.8.1 (20131002) build.

> Setting 'jump' to NULL may hide reall issues in case the code is changed
> in the future, so it is not appropriate a fix. Hence why the previously-
> submitted patches were not applied.
> 
> I'll take this on me to properly fix this. Thanks for the heads up.
> 
> Regards,
> Yann E. MORIN.
> 

