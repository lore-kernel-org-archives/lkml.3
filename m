Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3CTS54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:57:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:45142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3CTS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:57:54 -0400
Message-ID: <514A06B8.9060808@infradead.org>
Date: Wed, 20 Mar 2013 11:58:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: linux-next: Tree for Mar 20 (vmcore)
References: <20130320160536.54e62fc11a3651494b710e3b@canb.auug.org.au> <5149E813.8060307@infradead.org> <alpine.DEB.2.02.1303201153330.17761@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1303201153330.17761@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/13 11:56, David Rientjes wrote:
> On Wed, 20 Mar 2013, Randy Dunlap wrote:
> 
>> on x86_64:
>>
>> fs/proc/vmcore.c: In function 'merge_note_headers_elf64':
>> fs/proc/vmcore.c:349:22: error: 'VMCOREINFO_NOTE_NAME' undeclared (first use in this function)
>> fs/proc/vmcore.c:349:22: note: each undeclared identifier is reported only once for each function it appears in
>> fs/proc/vmcore.c: In function 'merge_note_headers_elf32':
>> fs/proc/vmcore.c:470:22: error: 'VMCOREINFO_NOTE_NAME' undeclared (first use in this function)
>> make[3]: *** [fs/proc/vmcore.o] Error 1
>>
>>
>> Needs to #include <linux/kexec.h>
>>
> 
> I don't think that's it, linux/kexec.h already gets included indirectly.  
> The problem is that CONFIG_KEXEC isn't set so the definition in kexec.h is 
> meaningless.

Thanks.   I meant to check on CONFIG_KEXEC and then forgot to do that.

> This comes from "vmcore: check NT_VMCORE_PAD as a mark indicating the end 
> of ELF note buffer" merged through the -mm tree.  I've added the patch's 
> author and Andrew to the cc.
> 
> How can this be protected by CONFIG_KEXEC?
> --


-- 
~Randy
