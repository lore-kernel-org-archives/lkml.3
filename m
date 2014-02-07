Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaBGUlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:41:42 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60212 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaBGUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:41:41 -0500
Date: Fri, 7 Feb 2014 12:41:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
In-Reply-To: <52F4B8A4.70405@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1402071239301.4212@chino.kir.corp.google.com>
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org> <alpine.DEB.2.02.1402061456290.31828@chino.kir.corp.google.com> <20140206152219.45c2039e5092c8ea1c31fd38@linux-foundation.org>
 <alpine.DEB.2.02.1402061537180.3441@chino.kir.corp.google.com> <alpine.DEB.2.02.1402061557210.5061@chino.kir.corp.google.com> <52F4B8A4.70405@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Raghavendra K T wrote:

> So following discussion TODO for my patch is:
> 
> 1) Update the changelog with user visible impact of the patch.
> (Andrew's suggestion)
> 2) Add ACCESS_ONCE to numa_node_id().
> 3) Change the "readahead into remote memory" part of the documentation
> which is misleading.
> 
> ( I feel no need to add numa_mem_id() since we would specifically limit
> the readahead with MAX_REMOTE_READAHEAD in memoryless cpu cases).
> 

I don't understand what you're saying, numa_mem_id() is local memory to 
current's cpu.  When a node consists only of cpus and not memory it is not 
true that all memory is then considered remote, you won't find that in any 
specification that defines memory affinity including the ACPI spec.  I can 
trivially define all cpus on my system to be on memoryless nodes and 
having that affect readahead behavior when, in fact, there is affinity 
would be ridiculous.
