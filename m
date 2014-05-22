Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaEVH0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:26:14 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36580 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbaEVH0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:26:12 -0400
Date: Thu, 22 May 2014 08:26:01 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
Message-ID: <20140522072601.GP4798@console-pimps.org>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
 <537A2A28.4010903@citrix.com>
 <20140519210255.GC3529@olila.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519210255.GC3529@olila.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May, at 11:02:55PM, Daniel Kiper wrote:
> 
> It is correct. As I said earlier: in case of !efi_enabled(EFI_DIRECT) some
> structures are created artificially and they live in virtual address space.
> So that is why they should not be mapped.
 
So, exploring Jan's idea, is it not possible to store the physical
address and have early_ioremap() just work? Even if they're mapping in
virtual address space they must have a corresponding physical address.

We really need to be keeping these kinds of special code paths to a
minimum. Unless absolutely necessary there should be just one way to do
things.

> I was going to have EFI_DIRECT close to EFI_BOOT which is quite generic
> and platform independent name like EFI_BOOT. However, I do not insist
> on having it in that place.

Right, please don't shuffle these bits.

-- 
Matt Fleming, Intel Open Source Technology Center
