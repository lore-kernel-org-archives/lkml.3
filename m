Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaCJOnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:43:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaCJOnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:43:21 -0400
Date: Mon, 10 Mar 2014 10:42:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 10/11] kexec: Support for loading ELF x86_64 images
Message-ID: <20140310144237.GA4352@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-11-git-send-email-vgoyal@redhat.com>
 <20140228145832.GF4326@pd.tnic>
 <20140228171142.GI28744@redhat.com>
 <20140307171233.GD5255@pd.tnic>
 <20140307183959.GE5255@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307183959.GE5255@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 07:39:59PM +0100, Borislav Petkov wrote:

[..]
> > Well, this is mandated by the boot protocol, no?
> > 
> > "If the "HdrS" (0x53726448) magic number is not found at offset 0x202,
> > the boot protocol version is "old".  Loading an old kernel, the
> > following parameters should be assumed:
> > 
> >         Image type = zImage
> >         initrd not supported
> >         Real-mode kernel must be located at 0x90000."
> > 
> > About version 0x0206:
> > 
> > Field name:     cmdline_size
> > Type:           read
> > Offset/size:    0x238/4
> > Protocol:       2.06+
> > 
> >   The maximum size of the command line without the terminating
> >   zero. This means that the command line can contain at most
> >   cmdline_size characters. With protocol version 2.05 and earlier, the
> >   maximum size was 255.
> > 
> > So according to the protocol, cmdline_size should be set by
> > kexec_file_load and not hardcoded to 2K, if we're mandating protocol
> > version 2.06.
> 
> Btw, all those fields above are of type "read", which means,
> 
> "For each field, some are information from the kernel to the bootloader
> ("read"),... "
> 
> Now, if we assume that the first kernel is the bootloader and it loads
> the second kernel, then the first kernel shouldn't be setting all those
> fields *at* *all* because it violates the boot protocol. And that's a
> no-no.

Yes, that's a read only information for bootloader.

> 
> Generally, how important is that use case for loading ELF images? If no
> one is actually using it, why even bother?
> 

Distributions use bzImage for booting. Personally I have not seen anybody
using ELF vmliux for booting.

When I posted V1 of patches, Eric Biederman had said that without ELF
loader support this patchset should not go in. He said that ELF is very
generic and if we are implementing a new system call we should support
ELF loader.

So I have put a basic ELF loader in patches to show that it can work. Not
that I am very keen on it.

I will gladly remove it if others are comfortable with the idea that we
don't need an ELF loader at this point of time.

Thanks
Vivek
