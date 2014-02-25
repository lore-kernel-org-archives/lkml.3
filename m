Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaBYRfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:35:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:65329 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaBYRfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:35:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,541,1389772800"; 
   d="scan'208";a="489593593"
Message-ID: <530CD443.7010400@intel.com>
Date: Tue, 25 Feb 2014 09:34:59 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
References: <1393284484-27637-1-git-send-email-agraf@suse.de>
In-Reply-To: <1393284484-27637-1-git-send-email-agraf@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 03:28 PM, Alexander Graf wrote:
> Configuration of tunables and Linux virtual memory settings has traditionally
> happened via sysctl. Thanks to that there are well established ways to make
> sysctl configuration bits persistent (sysctl.conf).
> 
> KSM introduced a sysfs based configuration path which is not covered by user
> space persistent configuration frameworks.
> 
> In order to make life easy for sysadmins, this patch adds all access to all
> KSM tunables via sysctl as well. That way sysctl.conf works for KSM as well,
> giving us a streamlined way to make KSM configuration persistent.

Doesn't this essentially mean "don't use sysfs for configuration"?
Seems like at least /sys/kernel/mm/transparent_hugepage would need the
same treatment.

Couldn't we also (maybe in parallel) just teach the sysctl userspace
about sysfs?  This way we don't have to do parallel sysctls and sysfs
for *EVERYTHING* in the kernel:

	sysfs.kernel.mm.transparent_hugepage.enabled=enabled

Or do we just say "sysctls are the way to go for anything that might
need to be persistent, don't use sysfs"?
