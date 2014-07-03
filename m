Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaGCCXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:23:35 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:36767 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGCCXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:23:34 -0400
Date: Thu, 3 Jul 2014 10:23:26 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
Message-ID: <20140703022326.GA5174@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <53AAFDF7.2010607@oracle.com>
 <alpine.DEB.2.11.1406251228130.29216@gentwo.org>
 <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com>
 <alpine.DEB.2.11.1407010956470.5353@gentwo.org>
 <20140701144947.5ce3f93729759d8f38d7813a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701144947.5ce3f93729759d8f38d7813a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070302-9574-0000-0000-00000EACB0D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 02:49:47PM -0700, Andrew Morton wrote:
>On Tue, 1 Jul 2014 09:58:52 -0500 (CDT) Christoph Lameter <cl@gentwo.org> wrote:
>
>> On Mon, 30 Jun 2014, David Rientjes wrote:
>> 
>> > It's not at all clear to me that that patch is correct.  Wei?
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
>Well, um.  Wei's changelog was much better:
>
>: When a kmem_cache is created with ctor, each object in the kmem_cache will
>: be initialized before use.  In the slub implementation, the first object
>: will be initialized twice.
>: 
>: This patch avoids the duplication of initialization of the first object.
>: 
>: Fixes commit 7656c72b5a63: ("SLUB: add macros for scanning objects in a
>: slab").
>
>I can copy that text over and add the reported-by etc (ho hum) but I
>have a tiny feeling that this patch hasn't been rigorously tested? 
>Perhaps someone (Wei?) can do that?

The result of the simple test is the same. And my laptop works a whole day
with this patch.

Thanks

>
>And we still don't know why Sasha's kernel went oops.

-- 
Richard Yang
Help you, Help me

