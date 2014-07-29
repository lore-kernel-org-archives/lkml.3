Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaG2JSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:18:07 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:61404 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaG2JSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:18:05 -0400
Date: Tue, 29 Jul 2014 02:18:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
cc: Dave Hansen <dave.hansen@intel.com>, mgorman@suse.de,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, wangnan0@huawei.com,
        Linux MM <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] memory hotplug: update the variables after memory
 removed
In-Reply-To: <53D75E13.8000702@huawei.com>
Message-ID: <alpine.DEB.2.02.1407290216520.13227@chino.kir.corp.google.com>
References: <1406619310-20555-1-git-send-email-zhenzhang.zhang@huawei.com> <53D74EE5.1070308@huawei.com> <alpine.DEB.2.02.1407290046470.7998@chino.kir.corp.google.com> <53D75E13.8000702@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Zhang Zhen wrote:

> >> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> >> index df1a992..fd7bd6b 100644
> >> --- a/arch/x86/mm/init_64.c
> >> +++ b/arch/x86/mm/init_64.c
> >> @@ -673,15 +673,11 @@ void __init paging_init(void)
> >>   * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
> >>   * updating.
> >>   */
> >> -static void  update_end_of_memory_vars(u64 start, u64 size)
> >> +static void  update_end_of_memory_vars(u64 end_pfn)
> > 
> > Extra space that can be removed here at the same time as a cleanup.
> > 
> Sorry, where is the extra space here?
> 

There are two spaces between the function identifier and the function 
type whereas there is traditionally only one.  It existed before your 
patch, it would just be nice to clean it up since you're already touching 
the line.
