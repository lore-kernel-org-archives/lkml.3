Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaBRWqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:46:16 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48881 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaBRWqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:03 -0500
Date: Tue, 18 Feb 2014 14:46:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>, nacc@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 ] mm readahead: Fix readahead fail for memoryless cpu
 and limit readahead pages
In-Reply-To: <20140218143838.aee7a4f0c94ab28b3b04c1e4@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1402181441360.20772@chino.kir.corp.google.com>
References: <1392708338-19685-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <alpine.DEB.2.02.1402181421590.20772@chino.kir.corp.google.com> <20140218143838.aee7a4f0c94ab28b3b04c1e4@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Andrew Morton wrote:

> > I'm not sure I understand why we want to be independent of PAGE_SIZE since 
> > we're still relying on PAGE_CACHE_SIZE.  Don't you mean to do
> > 
> > #define MAX_READAHEAD	((512*PAGE_SIZE)/PAGE_CACHE_SIZE)
> 
> MAX_READAHEAD is in units of "pages".
> 
> This:
> 
> +#define MAX_READAHEAD   ((512*4096)/PAGE_CACHE_SIZE)
> 
> means "two megabytes", and is implemented in a way to ensure that
> MAX_READAHEAD=2mb on 4k pagesize as well as on 64k pagesize.  Because
> we don't want variations in PAGE_SIZE to cause alterations in readahead
> behavior.
> 

Ah, ok, so 2MB is the magic value that we limit readhead to on all 
architectures.  512 * 4096 is a strange way to write 2MB, but ok :)
