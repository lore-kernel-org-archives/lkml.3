Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaEORcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:32:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51354 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbaEORcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:32:17 -0400
Message-ID: <5374FA04.5@oracle.com>
Date: Thu, 15 May 2014 13:31:48 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
References: <51559150.3040407@oracle.com> <515D882E.6040001@oracle.com> <533F09F0.1050206@oracle.com> <20140407144835.GA17774@node.dhcp.inet.fi> <5342FF3E.6030306@oracle.com> <20140407201106.GA21633@node.dhcp.inet.fi>
In-Reply-To: <20140407201106.GA21633@node.dhcp.inet.fi>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 04:11 PM, Kirill A. Shutemov wrote:
> On Mon, Apr 07, 2014 at 03:40:46PM -0400, Sasha Levin wrote:
>> > It also breaks fairly quickly under testing because:
>> > 
>> > On 04/07/2014 10:48 AM, Kirill A. Shutemov wrote:
>>> > > +	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
>>> > > +		spin_lock(ptl);
>> > 
>> > ^ We go into atomic
>> > 
>>> > > +		if (unlikely(!pmd_same(*pmd, orig_pmd)))
>>> > > +			goto out_race;
>>> > > +	}
>>> > > +
>>> > >  	if (!page)
>>> > >  		clear_huge_page(new_page, haddr, HPAGE_PMD_NR);
>>> > >  	else
>>> > >  		copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
>> > 
>> > copy_user_huge_page() doesn't like running in atomic state,
>> > and asserts might_sleep().
> Okay, I'll try something else.

I've Cc'ed Josh Boyer to this since it just occurred to me that Fedora
is running with CONFIG_DEBUG_VM set, where this bug is rather easy to
trigger.

This issue was neglected because it triggers only on CONFIG_DEBUG_VM builds,
but with Fedora running that, maybe it shouldn't be?


Thanks,
Sasha
