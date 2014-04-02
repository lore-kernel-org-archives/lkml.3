Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbaDBEq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 00:46:28 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:58898 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaDBEq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 00:46:26 -0400
Message-ID: <533B95F6.2010303@linux.vnet.ibm.com>
Date: Wed, 02 Apr 2014 10:15:42 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org, mingo@kernel.org
Subject: Re: [PATCH 1/1] mm: move FAULT_AROUND_ORDER to arch/
References: <1395730215-11604-1-git-send-email-maddy@linux.vnet.ibm.com> <1395730215-11604-2-git-send-email-maddy@linux.vnet.ibm.com> <20140325173605.GA21411@node.dhcp.inet.fi> <5331C1C9.5020309@intel.com>
In-Reply-To: <5331C1C9.5020309@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040204-3568-0000-0000-000005316054
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2014 11:20 PM, Dave Hansen wrote:
> On 03/25/2014 10:36 AM, Kirill A. Shutemov wrote:
>>>> +/*
>>>> + * Fault around order is a control knob to decide the fault around pages.
>>>> + * Default value is set to 0UL (disabled), but the arch can override it as
>>>> + * desired.
>>>> + */
>>>> +#ifndef FAULT_AROUND_ORDER
>>>> +#define FAULT_AROUND_ORDER	0UL
>>>> +#endif
>> FAULT_AROUND_ORDER == 0 case should be handled separately in
>> do_read_fault(): no reason to go to do_fault_around() if we are going to
>> fault in only one page.
> 
> Isn't this the kind of thing we want to do in Kconfig?
> 
> 
I am still investigating this option since this looks better. But it is
taking time, my bad. I will get back on this.

With Regards
Maddy

