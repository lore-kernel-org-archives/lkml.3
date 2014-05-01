Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaEAPF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:05:56 -0400
Received: from imap.thunk.org ([74.207.234.97]:43889 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaEAPFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:05:55 -0400
Date: Thu, 1 May 2014 15:05:49 +0000
From: tytso@mit.edu
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Florian Weimer <fweimer@redhat.com>,
        linux-kernel@vger.kernel.org, Kees Cook <kees@outflux.net>
Subject: Re: [PATCH] random: Add "initialized" variable to proc
Message-ID: <20140501150549.GA24388@thunk.org>
Mail-Followup-To: tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Florian Weimer <fweimer@redhat.com>, linux-kernel@vger.kernel.org,
	Kees Cook <kees@outflux.net>
References: <20140428195913.E0A0143994596@oldenburg.str.redhat.com>
 <20140428214112.GC7857@thunk.org>
 <535FE68C.8060002@redhat.com>
 <20140429182610.GA19325@thunk.org>
 <53616293.3080308@mit.edu>
 <20140501020627.GA25248@thunk.org>
 <1be5350d-89f9-44b9-8d1b-e3e591741940@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1be5350d-89f9-44b9-8d1b-e3e591741940@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 09:05:00PM -0700, H. Peter Anvin wrote:
> 
> Giving the guest a seed would be highly useful, though.  There are a
> number of ways to do that; changing the boot protocol is probably
> only useful if Qemu itself bouts the kernel as opposed to an in-VM
> bootloader.

So how about simply passing a memory address and an optional offset on
the boot command line?  That way the hypervisor can drop the seed in
some convenient real memory location, and the kernel can just copy it
someplace safe, or in the case of kernel ASLR, the relocator can use
it to seed its CRNG, and then after it relocates the kernel, it can
crank the CRNG to pass a seed to the kernel's urandom driver.

That way, we don't have to do something which is ACPI or DT dependent.
Maybe there will be embedded architectures where using DT might be
more convenient, but this would probably be simplest for KVM/qumu-based
VM's, I would think.

     	     	   	      		- Ted
