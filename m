Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaCUWhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:37:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46464 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaCUWhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:37:23 -0400
Message-ID: <532CBF08.4030100@oracle.com>
Date: Fri, 21 Mar 2014 18:36:56 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>
CC: Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        hhuang@redhat.com, knoel@redhat.com, aarcange@redhat.com,
        Davidlohr Bueso <davidlohr@hp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: numa: Recheck for transhuge pages under lock during
 protection changes
References: <20140307182745.GD1931@suse.de>	<20140311162845.GA30604@suse.de>	<531F3F15.8050206@oracle.com>	<531F4128.8020109@redhat.com>	<531F48CC.303@oracle.com>	<20140311180652.GM10663@suse.de>	<531F616A.7060300@oracle.com>	<20140311122859.fb6c1e772d82d9f4edd02f52@linux-foundation.org>	<20140312103602.GN10663@suse.de>	<5323C5D9.2070902@oracle.com>	<20140319143831.GA4751@suse.de> <20140321150658.386926ac3afa263946b1a2aa@linux-foundation.org>
In-Reply-To: <20140321150658.386926ac3afa263946b1a2aa@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 06:06 PM, Andrew Morton wrote:
> On Wed, 19 Mar 2014 14:38:32 +0000 Mel Gorman<mgorman@suse.de>  wrote:
>
>> >On Fri, Mar 14, 2014 at 11:15:37PM -0400, Sasha Levin wrote:
>>> > >On 03/12/2014 06:36 AM, Mel Gorman wrote:
>>>> > > >Andrew, this should go with the patches
>>>> > > >mmnuma-reorganize-change_pmd_range.patch
>>>> > > >mmnuma-reorganize-change_pmd_range-fix.patch
>>>> > > >move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
>>>> > > >in mmotm please.
>>>> > > >
>>>> > > >Thanks.
>>>> > > >
>>>> > > >---8<---
>>>> > > >From: Mel Gorman<mgorman@suse.de>
>>>> > > >Subject: [PATCH] mm: numa: Recheck for transhuge pages under lock during protection changes
>>>> > > >
>>>> > > >Sasha Levin reported the following bug using trinity
>>> > >
>>> > >I'm seeing a different issue with this patch. A NULL ptr deref occurs in the
>>> > >pte_offset_map_lock() macro right before the new recheck code:
>>> > >
>> >
>> >This on top?
>> >
>> >I tried testing it but got all sorts of carnage that trinity throw up
>> >in the mix and ordinary testing does not trigger the race. I've no idea
>> >which of the current mess of trinity-exposed bugs you've encountered and
>> >got fixed already.
>> >
> Where are we at with this one?

Looking good here, haven't seen any of the issues reported in this thread.


Thanks,
Sasha
