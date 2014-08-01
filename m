Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaHAJKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:10:42 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:60408 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaHAJKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:10:40 -0400
Date: Fri, 1 Aug 2014 02:10:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 2/3] mm, oom: remove unnecessary check for NULL
 zonelist
In-Reply-To: <20140731152659.GB9952@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1408010159500.4061@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407231814110.22326@chino.kir.corp.google.com> <alpine.DEB.2.02.1407231815090.22326@chino.kir.corp.google.com> <20140731152659.GB9952@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Johannes Weiner wrote:

> out_of_memory() wants the zonelist that was used during allocation,
> not just the random first node's zonelist that's simply picked to
> serialize page fault OOM kills system-wide.
> 
> This would even change how panic_on_oom behaves for page fault OOMs
> (in a completely unpredictable way) if we get CONSTRAINED_CPUSET.
> 
> This change makes no sense to me.
> 

Allocations during fault will be constrained by the cpuset's mems, if we 
are oom then why would we panic when panic_on_oom == 1?
