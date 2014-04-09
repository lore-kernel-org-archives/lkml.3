Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753AbaDIPvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:51:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:62851 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933002AbaDIPvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:51:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,826,1389772800"; 
   d="scan'208";a="490056826"
Message-ID: <53456B61.1040901@intel.com>
Date: Wed, 09 Apr 2014 08:46:41 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org
CC: benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org, mingo@kernel.org
Subject: Re: [PATCH V2 1/2] mm: move FAULT_AROUND_ORDER to arch/
References: <1396592835-24767-1-git-send-email-maddy@linux.vnet.ibm.com> <1396592835-24767-2-git-send-email-maddy@linux.vnet.ibm.com> <533EDB63.8090909@intel.com> <5344A312.80802@linux.vnet.ibm.com>
In-Reply-To: <5344A312.80802@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 06:32 PM, Madhavan Srinivasan wrote:
>> > In mm/Kconfig, put
>> > 
>> > 	config FAULT_AROUND_ORDER
>> > 		int
>> > 		default 1234 if POWERPC
>> > 		default 4
>> > 
>> > The way you have it now, every single architecture that needs to enable
>> > this has to go put that in their Kconfig.  That's madness.  This way,
> I though about it and decided not to do this way because, in future,
> sub platforms of the architecture may decide to change the values. Also,
> adding an if line for each architecture with different sub platforms
> oring to it will look messy.

I'm not sure why I'm trying here any more.  You do seem quite content to
add as much cruft to ppc and every other architecture as possible.  If
your theoretical scenario pops up, you simply do this in ppc:

config ARCH_FAULT_AROUND_ORDER
	int
	default 999
	default 888 if OTHER_SILLY_POWERPC_SUBARCH

But *ONLY* in the architectures that care about doing that stuff.  You
leave every other architecture on the planet alone.  Then, in mm/Kconfig:

config FAULT_AROUND_ORDER
	int
	default ARCH_FAULT_AROUND_ORDER if ARCH_FAULT_AROUND_ORDER
	default 4

Your way still requires going and individually touching every single
architecture's Kconfig that wants to enable fault around.  That's not an
acceptable solution.
