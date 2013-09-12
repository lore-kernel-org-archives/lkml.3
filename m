Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab3ILHfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab3ILHfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:35:06 -0400
Date: Thu, 12 Sep 2013 15:34:15 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, akpm@linux-foundation.org,
        zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        ebiederm@xmission.com, matthew.garrett@nebula.com
Subject: Re: [PATCH 15/16] bootparam: Pass acpi_rsdp pointer in bootparam
Message-ID: <20130912064930.GA5288@dhcp-16-126.nay.redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
 <1378849471-10521-16-git-send-email-vgoyal@redhat.com>
 <522FA2A8.8080703@zytor.com>
 <20130911114419.GB31551@x1.alien8.de>
 <20130911134534.GB15364@redhat.com>
 <20130911143216.GA933@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911143216.GA933@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/13 at 04:32pm, Borislav Petkov wrote:
> On Wed, Sep 11, 2013 at 09:45:34AM -0400, Vivek Goyal wrote:
> > I am looking forward to that new version. CCing Dave Young. He is also
> > looking into it and going through history of patches.
> 
> Ok, I'll CC you guys on the submission - I'd need any and all feedback I
> can get on that topic.

I'm playing with skipping SetVirtualAddressMap in kexec kernel, for same kernel
the test result is ok for me both for kexec and kdump. Takao Indoh sent a patch
with this approatch, but his V2 switched to use physical mapping.
During my test, additional data of config table elems need to be saved besides of
fw_vendor, runtime and tables or dereference taglep->guid will panic.

Also kexec userspace need to fill efi_info in bootparams and pass the previous
saved efi data to 2nd kernel.

I'm worrying just skiping enter virt mode have risk though it's an easy solution.
Your 1:1 mapping approatch looks better. I look forward to test your new patchset.
Are you also working on kexec userspace part? Already have a patch?

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
> Boris.
