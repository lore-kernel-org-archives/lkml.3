Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaCYSGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:06:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:36323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbaCYSGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:06:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="479768285"
Message-ID: <5331C1C9.5020309@intel.com>
Date: Tue, 25 Mar 2014 10:50:01 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org, mingo@kernel.org
Subject: Re: [PATCH 1/1] mm: move FAULT_AROUND_ORDER to arch/
References: <1395730215-11604-1-git-send-email-maddy@linux.vnet.ibm.com> <1395730215-11604-2-git-send-email-maddy@linux.vnet.ibm.com> <20140325173605.GA21411@node.dhcp.inet.fi>
In-Reply-To: <20140325173605.GA21411@node.dhcp.inet.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 10:36 AM, Kirill A. Shutemov wrote:
>> > +/*
>> > + * Fault around order is a control knob to decide the fault around pages.
>> > + * Default value is set to 0UL (disabled), but the arch can override it as
>> > + * desired.
>> > + */
>> > +#ifndef FAULT_AROUND_ORDER
>> > +#define FAULT_AROUND_ORDER	0UL
>> > +#endif
> FAULT_AROUND_ORDER == 0 case should be handled separately in
> do_read_fault(): no reason to go to do_fault_around() if we are going to
> fault in only one page.

Isn't this the kind of thing we want to do in Kconfig?
