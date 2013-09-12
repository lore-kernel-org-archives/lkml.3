Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3ILPVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:21:32 -0400
Received: from www.sr71.net ([198.145.64.142]:35973 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3ILPVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:21:31 -0400
Message-ID: <5231DBE9.2090008@sr71.net>
Date: Thu, 12 Sep 2013 08:21:13 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: percpu pages: up batch size to fix arithmetic??
 errror
References: <20130911220859.EB8204BB@viggo.jf.intel.com> <5230F7DD.90905@linux.vnet.ibm.com> <5230FB0A.70901@linux.vnet.ibm.com> <523108B7.7050101@sr71.net> <00000141128835e1-8664ca3a-c439-4d9d-89cb-308664595db4-000000@email.amazonses.com>
In-Reply-To: <00000141128835e1-8664ca3a-c439-4d9d-89cb-308664595db4-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 07:16 AM, Christoph Lameter wrote:
> On Wed, 11 Sep 2013, Dave Hansen wrote:
> 
>> 3. We want ->high to approximate the size of the cache which is
>>    private to a given cpu.  But, that's complicated by the L3 caches
>>    and hyperthreading today.
> 
> well lets keep it well below that. There are other caches (slab related
> f.e.) that are also in constant use.

At the moment, we've got a on-size-fits-all approach.  If you have more
than 512MB of RAM in a zone, you get the high=186(744kb)/batch=31(124kb)
behavior.  On my laptop, I've got 3500kB of L2+L3 for 4 logical cpus, or
~875kB/cpu.  According to what you're saying, the high mark is probably
a _bit_ too high.  On a modern server CPU, the caches are about double
that (per cpu).

>> I'll take one of my big systems and run it with some various ->high
>> settings and see if it makes any difference.
> 
> Do you actually see contention issues on the locks? I think we have a
> tendency to batch too much in too many caches.

Nope.  This all came out of me wondering what that /=4 did.  It's pretty
clear that we've diverged a bit from what the original intent of the
code was.  We need to at _least_ fix the comments up.
