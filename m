Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaJNQn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:43:56 -0400
Received: from smtp.citrix.com ([66.165.176.89]:20850 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbaJNQnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:43:55 -0400
X-IronPort-AV: E=Sophos;i="5.04,718,1406592000"; 
   d="scan'208";a="181221212"
Message-ID: <543D52C5.3010903@citrix.com>
Date: Tue, 14 Oct 2014 17:43:49 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: avoid writing to freed memory after
 race in p2m handling
References: <1413277218-11437-1-git-send-email-jgross@suse.com>	<543CED29.4050905@citrix.com> <543CF19B.3040305@suse.com>
In-Reply-To: <543CF19B.3040305@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/14 10:49, Juergen Gross wrote:
> On 10/14/2014 11:30 AM, David Vrabel wrote:
>> On 14/10/14 10:00, Juergen Gross wrote:
>>> In case a race was detected during allocation of a new p2m tree
>>> element in alloc_p2m() the new allocated mid_mfn page is freed without
>>> updating the pointer to the found value in the tree. This will result
>>> in overwriting the just freed page with the mfn of the p2m leaf.
>>
>> Can this race actually happen?  i.e., does this need tagging for stable?
> 
> Good question. I just stumbled over it while writing the linear p2m-list
> patch.
> 
> Is it possible for gnttab_map_refs() to call set_foreign_p2m_mapping()
> specifying a pfn which has been invalid before? In this case the race
> could happen in dom0.

Yes, if two backends map into ballooned pages from a region of
untouched,  pre-ballooned memory.  But these seems super rare and I
don't think there have been any bug reports that could be attributed to
this, so I don't think a stable backport is needed.

> I think ballooning alone can't trigger this race, as it is calling
> set_phys_to_machine() under lock only.

Agreed.

Applied to stable/for-linus-3.18.

Thanks.

David
