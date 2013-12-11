Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab3LKKUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:20:38 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:36403 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab3LKKUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:20:32 -0500
Date: Wed, 11 Dec 2013 10:20:25 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v5 01/14] x86/mm: sparse warning fix for early_memremap
Message-ID: <20131211102025.GB19196@console-pimps.org>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-2-git-send-email-dyoung@redhat.com>
 <20131209150521.GE31650@pd.tnic>
 <20131210021221.GA3800@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210021221.GA3800@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec, at 10:12:21AM, Dave Young wrote:
> On 12/09/13 at 04:05pm, Borislav Petkov wrote:
> > On Mon, Dec 09, 2013 at 05:42:14PM +0800, Dave Young wrote:
> > > There's a lot of sparse warnings for code like below:
> > > void *a = early_memremap(phys_addr, size);
> > > 
> > > early_memremap intend to map kernel memory with ioremap facility, the return
> > > pointer should be a kernel ram pointer instead of iomem one.
> > > 
> > > For making the function clearer and supressing sparse warnings this patch
> > > do below two things:
> > > 1. cast to (__force void *) for the return value of early_memremap
> > 
> > I'd guess this is to shut up the __iomem thing? And we're getting that
> > because we're using ioremap, ... hohum...
> 
> Yes, IMHO early_memremap really should not return __iomem pointer since it's
> *memremap*... 

This needs reviewing by at least one of the x86 folks, but it certainly
makes sense to me.

-- 
Matt Fleming, Intel Open Source Technology Center
