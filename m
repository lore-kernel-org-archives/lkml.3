Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaDDRtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:49:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53341 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaDDRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:49:22 -0400
Date: Fri, 04 Apr 2014 13:50:56 -0400 (EDT)
Message-Id: <20140404.135056.2103520199689146670.davem@davemloft.net>
To: dave.hansen@intel.com
Cc: maddy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, x86@kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, kirill.shutemov@linux.intel.com,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, ak@linux.intel.com, peterz@infradead.org,
        mingo@kernel.org
Subject: Re: [PATCH V2 1/2] mm: move FAULT_AROUND_ORDER to arch/
From: David Miller <davem@davemloft.net>
In-Reply-To: <533EDB63.8090909@intel.com>
References: <1396592835-24767-1-git-send-email-maddy@linux.vnet.ibm.com>
	<1396592835-24767-2-git-send-email-maddy@linux.vnet.ibm.com>
	<533EDB63.8090909@intel.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Apr 2014 10:49:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave.hansen@intel.com>
Date: Fri, 04 Apr 2014 09:18:43 -0700

> On 04/03/2014 11:27 PM, Madhavan Srinivasan wrote:
>> This patch creates infrastructure to move the FAULT_AROUND_ORDER
>> to arch/ using Kconfig. This will enable architecture maintainers
>> to decide on suitable FAULT_AROUND_ORDER value based on
>> performance data for that architecture. Patch also adds
>> FAULT_AROUND_ORDER Kconfig element in arch/X86.
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

It looks more like it's necessary only to change the default, not
to enable it.  Unless I read his patch wrong...
