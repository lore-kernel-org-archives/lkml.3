Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbaFIOPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbaFIOPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:15:17 -0400
Date: Mon, 9 Jun 2014 10:15:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] x86/boot: EFI_MIXED should not prohibit loading above 4G
Message-ID: <20140609141512.GA22049@redhat.com>
References: <1402140380-15377-1-git-send-email-matt@console-pimps.org>
 <20140609125427.GA16256@redhat.com>
 <CADknwL7Jeh82W3=rEqGqh=37zpqhmMuP1jy+DDq9vb2gQ+9hzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADknwL7Jeh82W3=rEqGqh=37zpqhmMuP1jy+DDq9vb2gQ+9hzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:18:54PM +0100, Matt Fleming wrote:
> On 9 June 2014 13:54, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi Matt,
> >
> > So with new kexec syscall I have written 64bit bzImage loader. For now
> > I would like to detect this situation and disable loading and once
> > 32bit loader gets implemented it can take care of loading bzImage below
> > 4G.
> 
> What situation do you want to detect? You want to detect when it's
> impossible to load a kernel above 4G in the kexec path because you're
> booting with 32-bit EFI firmware?

Yes.

> 
> > So how do I find out if EFI is 32bit.
> 
> efi_enabled(EFI_64BIT) will tell you that, but you probably also want
> to check that EFI runtime services are actually usable with
> efi_enabled(EFI_RUNTIME_SERVICES) since if they're not, you'll never
> call into the firmware so it doesn't matter where you load the kernel
> (this may happen with "noefi" kernel parameter).

Ok, thanks. Or I can check whether EFI run time map is there or not. I am
assuming that efi runtime services are not enabled, then run time map
will not be there either.

Thanks
Vivek
