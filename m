Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaKZOOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:14:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:47724 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaKZOOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:14:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="421765787"
Date: Wed, 26 Nov 2014 06:14:22 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        zheng.z.yan@intel.com, peterz@infradead.org, eranian@google.com
Subject: Re: perf/x86/intel/uncore: Add Haswell-EP uncore support
Message-ID: <20141126141422.GM10824@tassilo.jf.intel.com>
References: <20141013152950.11DE26610F1@gitolite.kernel.org>
 <20141125232050.GA9408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125232050.GA9408@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I couldn't quickly decipher which MSRs we're writing to here in the SDM,
> but are these really 64-bit wide registers that need 32 bits always set to zero ?

Yes the filter MSRs are only 32bit.

> I'm wondering if these should be just wrmsr's instead of wrmsrl's.

Can we just shut up coverity please?

wrmsr() is stupid and error prone and should have never been added as an
interface.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
