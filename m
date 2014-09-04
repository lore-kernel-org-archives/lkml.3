Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaIDO3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:29:52 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:49478 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaIDO3O convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 4 Sep 2014 10:29:14 -0400
Message-Id: <540893570200007800030E4C@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 04 Sep 2014 15:29:11 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: <xen-devel@lists.xensource.com>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, "Juergen Gross" <JGross@suse.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xen: eliminate scalability issues from initrd
 handling
References: <1409834326-29287-1-git-send-email-jgross@suse.com>
 <1409834326-29287-3-git-send-email-jgross@suse.com>
 <5408607F.6020108@citrix.com>
In-Reply-To: <5408607F.6020108@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.09.14 at 14:52, <david.vrabel@citrix.com> wrote:
> On 04/09/14 13:38, Juergen Gross wrote:
>> --- a/arch/x86/xen/xen-head.S
>> +++ b/arch/x86/xen/xen-head.S
>> @@ -124,6 +124,9 @@ NEXT_HYPERCALL(arch_6)
>>  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
>>  		.quad _PAGE_PRESENT; .quad _PAGE_PRESENT)
>>  	ELFNOTE(Xen, XEN_ELFNOTE_SUSPEND_CANCEL, .long 1)
>> +#ifdef CONFIG_X86_64
>> +	ELFNOTE(Xen, XEN_ELFNOTE_MOD_START_PFN,  .long 1)
>> +#endif
> 
> Why X86_64 only?  If there's a good reason the commit message needs to
> explain why.

Does native 32-bit support huge initrd?

Jan

