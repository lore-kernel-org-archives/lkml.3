Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbaIEIEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:04:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbaIEIE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:04:28 -0400
Message-ID: <54096E8A.6010904@suse.com>
Date: Fri, 05 Sep 2014 10:04:26 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>
CC: boris.ostrovsky@oracle.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 2/3] xen: eliminate scalability issues from
 initrd handling
References: <1409834326-29287-1-git-send-email-jgross@suse.com>	<1409834326-29287-3-git-send-email-jgross@suse.com>	<5408607F.6020108@citrix.com> <540893570200007800030E4C@mail.emea.novell.com> <54087CE3.6020400@citrix.com>
In-Reply-To: <54087CE3.6020400@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 04:53 PM, David Vrabel wrote:
> On 04/09/14 15:29, Jan Beulich wrote:
>>>>> On 04.09.14 at 14:52, <david.vrabel@citrix.com> wrote:
>>> On 04/09/14 13:38, Juergen Gross wrote:
>>>> --- a/arch/x86/xen/xen-head.S
>>>> +++ b/arch/x86/xen/xen-head.S
>>>> @@ -124,6 +124,9 @@ NEXT_HYPERCALL(arch_6)
>>>>   	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
>>>>   		.quad _PAGE_PRESENT; .quad _PAGE_PRESENT)
>>>>   	ELFNOTE(Xen, XEN_ELFNOTE_SUSPEND_CANCEL, .long 1)
>>>> +#ifdef CONFIG_X86_64
>>>> +	ELFNOTE(Xen, XEN_ELFNOTE_MOD_START_PFN,  .long 1)
>>>> +#endif
>>>
>>> Why X86_64 only?  If there's a good reason the commit message needs to
>>> explain why.
>>
>> Does native 32-bit support huge initrd?
>
> Does that matter? If the MOD_START_PFN options works with a 32-bit guest
> then it should use it, regardless of whether it is essential or not.
> Because this reduces the #ifdef'ery.

Okay, I'll verify it's working on 32-bit, too.


Juergen

