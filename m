Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaDGHGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 03:06:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:42534 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaDGHGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 03:06:02 -0400
Message-ID: <1396849534.3671.35.camel@pasglop>
Subject: Re: [PATCH V2 1/2] mm: move FAULT_AROUND_ORDER to arch/
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        paulus@samba.org, kirill.shutemov@linux.intel.com,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, ak@linux.intel.com, peterz@infradead.org,
        mingo@kernel.org
Date: Mon, 07 Apr 2014 15:45:34 +1000
In-Reply-To: <533EDB63.8090909@intel.com>
References: <1396592835-24767-1-git-send-email-maddy@linux.vnet.ibm.com>
	 <1396592835-24767-2-git-send-email-maddy@linux.vnet.ibm.com>
	 <533EDB63.8090909@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 09:18 -0700, Dave Hansen wrote:
> On 04/03/2014 11:27 PM, Madhavan Srinivasan wrote:
> > This patch creates infrastructure to move the FAULT_AROUND_ORDER
> > to arch/ using Kconfig. This will enable architecture maintainers
> > to decide on suitable FAULT_AROUND_ORDER value based on
> > performance data for that architecture. Patch also adds
> > FAULT_AROUND_ORDER Kconfig element in arch/X86.
> 
> Please don't do it this way.
> 
> In mm/Kconfig, put
> 
> 	config FAULT_AROUND_ORDER
> 		int
> 		default 1234 if POWERPC
> 		default 4
> 
> The way you have it now, every single architecture that needs to enable
> this has to go put that in their Kconfig.  That's madness.  This way,
> you only put it in one place, and folks only have to care if they want
> to change the default to be something other than 4.

Also does it have to be a constant ? Maddy here tested on our POWER
servers. The "Sweet spot" value might be VERY different on an embedded
chip or even on a future generation of server chip.

Cheers,
Ben.


