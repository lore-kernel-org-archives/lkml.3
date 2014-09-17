Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaIQOnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:43:03 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:19721 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaIQOm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:42:59 -0400
X-IronPort-AV: E=Sophos;i="5.04,540,1406592000"; 
   d="scan'208";a="173311786"
Message-ID: <54199DE7.6010306@citrix.com>
Date: Wed, 17 Sep 2014 15:42:47 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH V2 3/3] xen: eliminate scalability issues
 from initial mapping setup
References: <1410927157-15069-1-git-send-email-jgross@suse.com> <1410927157-15069-4-git-send-email-jgross@suse.com> <54199589.9040703@citrix.com> <541998CB.4000409@suse.com>
In-Reply-To: <541998CB.4000409@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/14 15:20, Juergen Gross wrote:
> On 09/17/2014 04:07 PM, David Vrabel wrote:
>> 
>>
>> Are you missing a ClearPagePinned(..) here?
> 
> Probably, yes.

Jan pointed out that this is not needed.

>>> @@ -1529,6 +1604,22 @@ static pte_t __init mask_rw_pte(pte_t *ptep,
>>> pte_t pte)
>>>   #else /* CONFIG_X86_64 */
>>>   static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
>>>   {
>>> +    unsigned long pfn;
>>> +
>>> +    if (xen_feature(XENFEAT_writable_page_tables) ||
>>> +        xen_feature(XENFEAT_auto_translated_physmap) ||
>>> +        xen_start_info->mfn_list >= __START_KERNEL_map)
>>> +        return pte;
>>> +
>>> +    /*
>>> +     * Pages belonging to the initial p2m list mapped outside the
>>> default
>>> +     * address range must be mapped read-only.
>>
>> Why?  I didn't think was anything special about these MFNs.
> 
> The hypervisor complained when I did otherwise. I think the main reason
> is that the hypervisor will set up some more page tables to be able to
> map then mfn_list outside the "normal" address range. They are located
> in the range starting at xen_start_info->first_p2m_pfn (otherwise the
> info in first_p2m_pfn and nr_p2m_frames wouldn't be needed).

Ok. Can you expand the comment to say this?

David
