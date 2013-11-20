Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3KTLkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:40:06 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:34698 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTLkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:40:03 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Michal Hocko <mhocko@suse.cz>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Aliasing VIPT dcache / Page colouring
Thread-Topic: Aliasing VIPT dcache / Page colouring
Thread-Index: Ac7l5ToNXIpBaFRqSEuUzTwTWfSLRg==
Date: Wed, 20 Nov 2013 11:39:54 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075156B6B@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

I read thru your fantastic work on Page coloring

http://d3s.mff.cuni.cz/publications/download/hocko-sipew10.pdf

and slightly different one at

http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.65.2260&rep=rep1&type=pdf

I had a few questions on your paper/code, which you could hopefully answer.

To give you some background, I maintain the Linux port to ARC cores (from Synopsys).  We have ARC700 core with VIPT, 4 way set associative, L1 dcache. With a PAGE_SIZE of 8k, dcache >= 64k can potentially suffer from VIPT aliasing (we don't have specific hardware assist). Kernel runs in untranslated address space, hence uses paddr as handle for r/w to page, which can potentially alias with a non congruent userspace mapping of page. Currently we work around by doing the needed preventive flushes in update_mmu_cache( ) and other hooks intended for this purpose (although adding kmap_atomic based mapping for @src in copy_user_highpage is still on my TODO list)

Regarding your paper/code I wanted to confirm my understanding that the scheme itself can't be used in general for VIPT aliasing issue (ignoring the intrusiveness to core VM, Linus detesting it ...). It seems to be targeted at large PIPT caches, primarily to help spread the cache access via coloring / bin hopping etc. Plus it relies on user space defining the hints. The file backed page mapping doesn't take the color allocation path at all so I can't see how it will work with VIPT at all. anon mappings cause pages allocation rightaway, breaking the lazy allocation paradigm.

Am I reading it correctly ?

TIA,
-Vineet
