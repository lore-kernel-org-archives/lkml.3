Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab3FKWUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:20:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37116 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3FKWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:20:12 -0400
Date: Tue, 11 Jun 2013 15:20:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Thorlton <athorlton@sgi.com>
cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] Make transparent hugepages cpuset aware
In-Reply-To: <1370967244-5610-1-git-send-email-athorlton@sgi.com>
Message-ID: <alpine.DEB.2.02.1306111517200.6141@chino.kir.corp.google.com>
References: <1370967244-5610-1-git-send-email-athorlton@sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013, Alex Thorlton wrote:

> This patch adds the ability to control THPs on a per cpuset basis.  Please see
> the additions to Documentation/cgroups/cpusets.txt for more information.
> 

What's missing from both this changelog and the documentation you point to 
is why this change is needed.

I can understand how you would want a subset of processes to not use thp 
when it is enabled.  This is typically where MADV_NOHUGEPAGE is used with 
some type of malloc hook.

I don't think we need to do this on a cpuset level, so unfortunately I 
think this needs to be reworked.  Would it make sense to add a per-process 
tunable to always get MADV_NOHUGEPAGE behavior for all of its sbrk() and 
mmap() calls?  Perhaps, but then you would need to justify why it can't be 
done with a malloc hook in userspace.

This seems to just be working around a userspace issue or for a matter of 
convenience, right?
