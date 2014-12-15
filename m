Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaLOLrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:47:18 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:56955 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLOLrP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:2>);
	Mon, 15 Dec 2014 06:47:15 -0500
Message-Id: <548ED84D020000780004F8FB@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Mon, 15 Dec 2014 11:47:09 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <david.vrabel@citrix.com>
Cc: <x86@kernel.org>, <tglx@linutronix.de>,
        "xen-devel" <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <mingo@redhat.com>, "Juergen Gross" <JGross@suse.com>,
        <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 1/4] xen: build infrastructure for
 generating hypercall depending symbols
References: <1418321065-10212-1-git-send-email-jgross@suse.com>
 <1418321065-10212-2-git-send-email-jgross@suse.com>
 <548EC841.2000107@citrix.com>
In-Reply-To: <548EC841.2000107@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.12.14 at 12:38, <david.vrabel@citrix.com> wrote:
> On 11/12/14 18:04, Juergen Gross wrote:
>> --- a/arch/x86/syscalls/Makefile
>> +++ b/arch/x86/syscalls/Makefile
> 
> Why are these changes here and not in arch/x86/xen/Makefile?

Because this needs to be done in a step that (afaict) has no hook
in the Xen-specific Makefile.

>> @@ -47,10 +50,16 @@ $(out)/syscalls_32.h: $(syscall32) $(systbl)
>>  $(out)/syscalls_64.h: $(syscall64) $(systbl)
>>  	$(call if_changed,systbl)
>>  
>> +$(out)/xen-hypercalls.h: $(srctree)/scripts/xen-hypercalls.sh
>> +	$(call if_changed,hypercalls)
>> +
>> +$(out)/xen-hypercalls.h: $(srctree)/include/xen/interface/xen*.h
> 
> The generated header should end up in asm/xen/

Why is generated/asm/ not good enough?

Jan

