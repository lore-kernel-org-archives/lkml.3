Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977AbaGAVwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:52:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19959 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbaGAVwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:52:17 -0400
Message-ID: <53B32D80.8000601@oracle.com>
Date: Tue, 01 Jul 2014 17:52:00 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>
CC: David Rientjes <rientjes@google.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
References: <53AAFDF7.2010607@oracle.com>	<alpine.DEB.2.11.1406251228130.29216@gentwo.org>	<alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com>	<alpine.DEB.2.11.1407010956470.5353@gentwo.org> <20140701144947.5ce3f93729759d8f38d7813a@linux-foundation.org>
In-Reply-To: <20140701144947.5ce3f93729759d8f38d7813a@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 05:49 PM, Andrew Morton wrote:
> On Tue, 1 Jul 2014 09:58:52 -0500 (CDT) Christoph Lameter <cl@gentwo.org> wrote:
> 
>> On Mon, 30 Jun 2014, David Rientjes wrote:
>>
>>> It's not at all clear to me that that patch is correct.  Wei?
>>
>> Looks ok to me. But I do not like the convoluted code in new_slab() which
>> Wei's patch does not make easier to read. Makes it difficult for the
>> reader to see whats going on.
>>
>> Lets drop the use of the variable named "last".
>>
>>
>> Subject: slub: Only call setup_object once for each object
>>
>> Modify the logic for object initialization to be less convoluted
>> and initialize an object only once.
>>
> 
> Well, um.  Wei's changelog was much better:
> 
> : When a kmem_cache is created with ctor, each object in the kmem_cache will
> : be initialized before use.  In the slub implementation, the first object
> : will be initialized twice.
> : 
> : This patch avoids the duplication of initialization of the first object.
> : 
> : Fixes commit 7656c72b5a63: ("SLUB: add macros for scanning objects in a
> : slab").
> 
> I can copy that text over and add the reported-by etc (ho hum) but I
> have a tiny feeling that this patch hasn't been rigorously tested? 
> Perhaps someone (Wei?) can do that?
> 
> And we still don't know why Sasha's kernel went oops.

I only saw this oops once, and after David's message yesterday I tried reverting
the patch he pointed out, but not much changed.

Is there a better way to stress test slub?


Thanks,
Sasha

