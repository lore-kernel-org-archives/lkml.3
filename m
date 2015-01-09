Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbbAIM5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:57:04 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:48717 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbbAIM5C convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 9 Jan 2015 07:57:02 -0500
Message-Id: <54AFDE2B0200007800053248@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 09 Jan 2015 12:56:59 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "Juergen Gross" <JGross@suse.com>
Cc: "xen-devel" <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen: use correct type for physical
 addresses
References: <1420736490-15351-1-git-send-email-jgross@suse.com>
 <1420736490-15351-4-git-send-email-jgross@suse.com>
 <54AFB410020000780005306E@mail.emea.novell.com>
 <54AFCED7.7040407@citrix.com>
In-Reply-To: <54AFCED7.7040407@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.01.15 at 13:51, <david.vrabel@citrix.com> wrote:
> On 09/01/15 09:57, Jan Beulich wrote:
>>>>> On 08.01.15 at 18:01, <JGross@suse.com> wrote:
>>> @@ -284,7 +286,7 @@ static void __init xen_update_mem_tables(unsigned long pfn, unsigned long mfn)
>>>  	}
>>>  
>>>  	/* Update kernel mapping, but not for highmem. */
>>> -	if ((pfn << PAGE_SHIFT) >= __pa(high_memory))
>>> +	if (PFN_PHYS(pfn) >= (u64)(__pa(high_memory)))
>> 
>> I don't think you really need the cast on the right side - __pa()
>> should be returning a value of suitable type (and unsigned long
>> would be sufficient for anything up to and including high_memory).
> 
> I'd prefer:
> 
>     if (pfn >= PFN_DOWN(__pa(high_memory))

Even better indeed. Just one more point: Strictly speaking
__pa(high_memory) is invalid, as __pa() is defined for low
memory only. Hence perhaps PFN_UP(__pa(high_memory - 1))?

Jan

