Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaIDOx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:53:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29804 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaIDOx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:53:26 -0400
X-IronPort-AV: E=Sophos;i="5.04,466,1406592000"; 
   d="scan'208";a="169116643"
Message-ID: <54087CE3.6020400@citrix.com>
Date: Thu, 4 Sep 2014 15:53:23 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>
CC: Juergen Gross <JGross@suse.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3] xen: eliminate scalability issues from
 initrd handling
References: <1409834326-29287-1-git-send-email-jgross@suse.com>	<1409834326-29287-3-git-send-email-jgross@suse.com>	<5408607F.6020108@citrix.com> <540893570200007800030E4C@mail.emea.novell.com>
In-Reply-To: <540893570200007800030E4C@mail.emea.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/14 15:29, Jan Beulich wrote:
>>>> On 04.09.14 at 14:52, <david.vrabel@citrix.com> wrote:
>> On 04/09/14 13:38, Juergen Gross wrote:
>>> --- a/arch/x86/xen/xen-head.S
>>> +++ b/arch/x86/xen/xen-head.S
>>> @@ -124,6 +124,9 @@ NEXT_HYPERCALL(arch_6)
>>>  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
>>>  		.quad _PAGE_PRESENT; .quad _PAGE_PRESENT)
>>>  	ELFNOTE(Xen, XEN_ELFNOTE_SUSPEND_CANCEL, .long 1)
>>> +#ifdef CONFIG_X86_64
>>> +	ELFNOTE(Xen, XEN_ELFNOTE_MOD_START_PFN,  .long 1)
>>> +#endif
>>
>> Why X86_64 only?  If there's a good reason the commit message needs to
>> explain why.
> 
> Does native 32-bit support huge initrd?

Does that matter? If the MOD_START_PFN options works with a 32-bit guest
then it should use it, regardless of whether it is essential or not.
Because this reduces the #ifdef'ery.

David
