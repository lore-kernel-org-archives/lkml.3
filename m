Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab3LKQNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:13:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3LKQNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:13:31 -0500
Message-ID: <1386775078.1979.98.camel@deneb.redhat.com>
Subject: Re: [PATCH v5 02/14] efi: use early_memremap and early_memunmap
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Dave Young <dyoung@redhat.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        Tony Luck <tony.luck@gmail.com>
Date: Wed, 11 Dec 2013 10:17:58 -0500
In-Reply-To: <20131211113207.GA29980@console-pimps.org>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
	 <1386582147-9802-3-git-send-email-dyoung@redhat.com>
	 <20131211103903.GC19196@console-pimps.org>
	 <20131211110227.GK22356@rocoto.smurfnet.nu>
	 <20131211113207.GA29980@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 11:32 +0000, Matt Fleming wrote:
> On Wed, 11 Dec, at 12:02:27PM, Leif Lindholm wrote:
> > On Wed, Dec 11, 2013 at 10:39:03AM +0000, Matt Fleming wrote:
> > > Leif, Mark, does this patch look OK for ARM? We'd need to introduce a
> > > new early_memunmap() function so that things still build, but that
> > > should be straight forward. You'd even be able to get rid of the
> > > asymmetry in uefi_init() where you map efi.systab with early_memremap()
> > > but unmap it with early_iounmap().
> > 
> > This patch looks splendid for ARM. As long as Mark can get the new
> > function into an update to the early_*remap() set, I can include this
> > in my next version - which is coming this week.
> 
> Great!
> 
> Oh and ia64 would also need early_memunmap(). Tony, the original patch
> is here,
> 

Couldn't ia64 just do:

  #define early_memremap(phys_addr, size) __va(phys_addr)
  #define early_memunmap(addr, size)

Anyway, I posted a patch to create a generic early_ioremap
implementation using generic bits of the x86 code:

  https://lkml.org/lkml/2013/11/27/621

So maybe Dave's patch 1/14 should be part of that series or
get rebased on top of it.

--Mark


