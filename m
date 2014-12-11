Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbaLKFRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 00:17:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaLKFRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 00:17:35 -0500
Message-ID: <548928ED.9060800@suse.com>
Date: Thu, 11 Dec 2014 06:17:33 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com
Subject: Re: [PATCH] xen: switch to post-init routines in xen mmu.c earlier
References: <1418226963-24873-1-git-send-email-jgross@suse.com> <20141210161353.GD4268@laptop.dumpdata.com>
In-Reply-To: <20141210161353.GD4268@laptop.dumpdata.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 05:13 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 10, 2014 at 04:56:03PM +0100, Juergen Gross wrote:
>> With the virtual mapped linear p2m list the post-init mmu operations
>> must be used for setting up the p2m mappings, as in case of
>> CONFIG_FLATMEM the init routines may trigger BUGs.
>
> Um, could you explain a bit more of why the CONFIG_FLATMEM
> is such unique? What about the other CONFIG_*MEM cases?

CONFIG_FLATMEM is just the configuration hitting a BUG() in
xen_alloc_pte_init() being used after finishing paging_init().

Juergen

>
>>
>> Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>   arch/x86/xen/mmu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>> index 6ab6150..a1a429a 100644
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -1225,6 +1225,7 @@ static void __init xen_pagetable_p2m_setup(void)
>>   static void __init xen_pagetable_init(void)
>>   {
>>   	paging_init();
>> +	xen_post_allocator_init();
>>
>>   	xen_pagetable_p2m_setup();
>>
>> @@ -1236,7 +1237,6 @@ static void __init xen_pagetable_init(void)
>>   		xen_remap_memory();
>>
>>   	xen_setup_shared_info();
>> -	xen_post_allocator_init();
>>   }
>>   static void xen_write_cr2(unsigned long cr2)
>>   {
>> --
>> 2.1.2
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

