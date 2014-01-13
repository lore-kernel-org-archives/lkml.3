Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaAMMXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:23:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbaAMMXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:23:44 -0500
Date: Mon, 13 Jan 2014 20:23:21 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Message-ID: <20140113122320.GA1900@darkstar.nay.redhat.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-2-git-send-email-bp@alien8.de>
 <20140113053240.GA11237@dhcp-16-126.nay.redhat.com>
 <20140113101822.GA5388@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113101822.GA5388@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > How about do not limit to only if (pgd) case, instead do something
> > like below: set dump_to_dmesg as a module parameter
> 
> X86_PTDUMP is not a module.

Hmm, I just see the module macros in the code, since it's a bool Kconfig
I think the dump_pagetables.c need a cleanup,
remove the #include <linux/module.h> and below lines:
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
MODULE_DESCRIPTION("Kernel debugging helper that dumps pagetables");

> 
> And even though the idea to make the efi pagetable dumpable with a
> kernel cmdline parameter doesn't sound all that bad, I'd like to hold
> off on adding yet another efi= cmdline option and only do so until it is
> really needed.

I think not necessary limit to efi=? Probably something like ptdump_dmesg=1|0 

Thanks
Dave
