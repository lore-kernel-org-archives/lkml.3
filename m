Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLPOwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:52:08 -0500
Received: from smtp.citrix.com ([66.165.176.89]:2404 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaLPOwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:52:07 -0500
X-IronPort-AV: E=Sophos;i="5.07,587,1413244800"; 
   d="scan'208";a="204917762"
Message-ID: <549046D4.8030304@citrix.com>
Date: Tue, 16 Dec 2014 14:51:00 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, <david.vrabel@citrix.com>
CC: Juergen Gross <JGross@suse.com>, <mmarek@suse.cz>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <hpa@zytor.com>,
        xen-devel <xen-devel@lists.xenproject.org>, <tglx@linutronix.de>,
        <boris.ostrovsky@oracle.com>, <linux-kbuild@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/4] xen: build infrastructure for generating
 hypercall depending symbols
References: <1418321065-10212-1-git-send-email-jgross@suse.com>	<1418321065-10212-2-git-send-email-jgross@suse.com>	<548EC841.2000107@citrix.com> <548ED84D020000780004F8FB@mail.emea.novell.com>
In-Reply-To: <548ED84D020000780004F8FB@mail.emea.novell.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/12/14 11:47, Jan Beulich wrote:
>>>> On 15.12.14 at 12:38, <david.vrabel@citrix.com> wrote:
>> On 11/12/14 18:04, Juergen Gross wrote:
>>> --- a/arch/x86/syscalls/Makefile
>>> +++ b/arch/x86/syscalls/Makefile
>>
>> Why are these changes here and not in arch/x86/xen/Makefile?
> 
> Because this needs to be done in a step that (afaict) has no hook
> in the Xen-specific Makefile.
> 
>>> @@ -47,10 +50,16 @@ $(out)/syscalls_32.h: $(syscall32) $(systbl)
>>>  $(out)/syscalls_64.h: $(syscall64) $(systbl)
>>>  	$(call if_changed,systbl)
>>>  
>>> +$(out)/xen-hypercalls.h: $(srctree)/scripts/xen-hypercalls.sh
>>> +	$(call if_changed,hypercalls)
>>> +
>>> +$(out)/xen-hypercalls.h: $(srctree)/include/xen/interface/xen*.h
>>
>> The generated header should end up in asm/xen/
> 
> Why is generated/asm/ not good enough?

I meant something like generated/asm/xen/hypercall-macros.h

So a "xen/" prefix which is consistent with all the other xen specific
headers.

But if this is non-trivial it's not a major issue.

David
