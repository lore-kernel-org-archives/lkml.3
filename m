Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbaIWNKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:10:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34975 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbaIWNKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:10:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,580,1406592000"; 
   d="scan'208";a="175273750"
Message-ID: <54217145.7090206@citrix.com>
Date: Tue, 23 Sep 2014 14:10:29 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <jbeulich@suse.com>
Subject: Re: [PATCH V3] xen: eliminate scalability issues from initial mapping
 setup
References: <1410965981-15444-1-git-send-email-jgross@suse.com> <1410965981-15444-2-git-send-email-jgross@suse.com> <5420EFD2.4070801@suse.com>
In-Reply-To: <5420EFD2.4070801@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/14 04:58, Juergen Gross wrote:
> On 09/17/2014 04:59 PM, Juergen Gross wrote:
>> Direct Xen to place the initial P->M table outside of the initial
>> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
>> restriction on the size of the initial mapping limits the amount
>> of memory a domain can be handed initially.
>>
>> As the initial P->M table is copied rather early during boot to
>> domain private memory and it's initial virtual mapping is dropped,
>> the easiest way to avoid virtual address conflicts with other
>> addresses in the kernel is to use a user address area for the
>> virtual address of the initial P->M table. This allows us to just
>> throw away the page tables of the initial mapping after the copy
>> without having to care about address invalidation.
>>
>> It should be noted that this patch won't enable a pv-domain to USE
>> more than 512 GB of RAM. It just enables it to be started with a
>> P->M table covering more memory. This is especially important for
>> being able to boot a Dom0 on a system with more than 512 GB memory.
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> Any Acks/Naks?

Sorry for the delay.  We only have one machine with 1 TB of RAM and it's
very busy.

>> +static void xen_cleanmfnmap_free_pgtbl(void *pgtbl)

This needs to be __init.  But I'll fix this up.  In future, can you make
sure you build with the option that finds these
(CONFIG_DEBUG_SECTION_MISMATCH).

David
