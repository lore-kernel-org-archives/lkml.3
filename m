Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaBZAKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:10:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:64806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbaBZAKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:10:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,543,1389772800"; 
   d="scan'208";a="489792277"
Message-ID: <530D3102.60504@intel.com>
Date: Tue, 25 Feb 2014 16:10:42 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
References: <1393284484-27637-1-git-send-email-agraf@suse.de> <530CD443.7010400@intel.com> <4B3C0B08-45E1-48EF-8030-A3365F0E7CF6@suse.de>
In-Reply-To: <4B3C0B08-45E1-48EF-8030-A3365F0E7CF6@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 03:09 PM, Alexander Graf wrote:
>> Couldn't we also (maybe in parallel) just teach the sysctl userspace
>> about sysfs?  This way we don't have to do parallel sysctls and sysfs
>> for *EVERYTHING* in the kernel:
>>
>>    sysfs.kernel.mm.transparent_hugepage.enabled=enabled
> 
> It's pretty hard to filter this. We definitely do not want to expose all of sysfs through /proc/sys. But how do we know which files are actual configuration and which ones are dynamic system introspection data?
> 
> We could add a filter, but then we can just as well stick with the manual approach I followed here :).

Maybe not stick it under /proc/sys, but teach sysctl(8) about them.  I
guess at the moment, sysctl says that it's tied to /proc/sys:

> DESCRIPTION
>        sysctl  is  used to modify kernel parameters at runtime.  The parameters available are those listed under /proc/sys/.  Procfs is required
>        for sysctl support in Linux.  You can use sysctl to both read and write sysctl data.

But surely that's not set in stone just because the manpage says so. :)
