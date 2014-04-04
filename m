Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaDDQUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:20:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:26490 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbaDDQUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:20:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,795,1389772800"; 
   d="scan'208";a="514948451"
Message-ID: <533EDB63.8090909@intel.com>
Date: Fri, 04 Apr 2014 09:18:43 -0700
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
References: <1396592835-24767-1-git-send-email-maddy@linux.vnet.ibm.com> <1396592835-24767-2-git-send-email-maddy@linux.vnet.ibm.com>
In-Reply-To: <1396592835-24767-2-git-send-email-maddy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 11:27 PM, Madhavan Srinivasan wrote:
> This patch creates infrastructure to move the FAULT_AROUND_ORDER
> to arch/ using Kconfig. This will enable architecture maintainers
> to decide on suitable FAULT_AROUND_ORDER value based on
> performance data for that architecture. Patch also adds
> FAULT_AROUND_ORDER Kconfig element in arch/X86.

Please don't do it this way.

In mm/Kconfig, put

	config FAULT_AROUND_ORDER
		int
		default 1234 if POWERPC
		default 4

The way you have it now, every single architecture that needs to enable
this has to go put that in their Kconfig.  That's madness.  This way,
you only put it in one place, and folks only have to care if they want
to change the default to be something other than 4.

