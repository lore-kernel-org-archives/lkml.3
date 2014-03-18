Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaCRNLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:11:39 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:4621 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbaCRNLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:11:37 -0400
From: "Zuckerman, Boris" <borisz@hp.com>
To: Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "Kani, Toshimitsu" <toshi.kani@hp.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [RFC PATCH] Support map_pages() for DAX
Thread-Topic: [RFC PATCH] Support map_pages() for DAX
Thread-Index: Ac9Cq3c4O0QmV5yiRcyQgqpCAI0hZw==
Date: Tue, 18 Mar 2014 13:10:44 +0000
Message-ID: <4C30833E5CDF444D84D942543DF65BDA625BD721@G4W3303.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

First of all, thank you for doing this job! 
Supporting persistent memory for any OS is bit more than adding "just another device".
There are some thoughts and questions below. Perhaps, you discussed those already. If so, please point me to that discussion!

> > Few questions:
> >  - why would you need Dirty for DAX?
> 
> One of the areas ignored by the original XIP code was CPU caches.  Maybe
> s390 has write-through caches or something, but on x86 we need to write back the
> lines from the CPU cache to the memory on an msync().  We'll also need to do this for
> a write(), although that's a SMOP.
> 

X86 cache lines are much smaller than a page. Cache lined are flushed "naturally", but we do not know about that.
How many Dirty pages do we anticipate? What is the performance cost of msync()? Is that higher, if we do page-based accounting?

Reasons and frequency of msync():
Atomicity: needs barriers, happens frequently, leaves relatively small number of Dirty pages. Here the cost is probably smaller. 
Durability of application updates: issued infrequently, leaves many Dirty pages. The cost could be high, right?

Let's assume that at some point we get CPU/Persistent Memory Controller combinations that support atomicity of multiple updates in hardware. Would you need to mark pages Dirty in such cases? If not, what is the right layer build that support for x86?
