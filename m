Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaFSOlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:41:19 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47088 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaFSOlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:41:17 -0400
Date: Thu, 19 Jun 2014 15:41:12 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
Message-ID: <20140619144112.GT24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
 <20140618135229.GH24049@console-pimps.org>
 <20140618164835.GD28489@olila.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618164835.GD28489@olila.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun, at 06:48:35PM, Daniel Kiper wrote:
> >
> > Why don't you want to export efi.fw_vendor, etc? Rationale please.
> 
> I am exporting real addresses (machine addresses) of things which
> I am able to get. Stuff which was created artificially and lives
> in dom0 address space or does not exist are not exported.
 
So, wouldn't it be easier to just leave those fields as
EFI_INVALID_TABLE_ADDR? If they're not usable why fill out an address?

> Hmmm... I do not know what is wrong with this minimal shuffling. We are
> playing here with internal stuff which is not visible outside of any
> given kernel. Additionally, as I saw in a few places arch bits are
> defined in following way:
> 
> #define ARCH_1 10
> 
> #define A_ARCH_CONST ARCH_1
> #define B_ARCH_CONST (ARCH_1 + 1)
> #define C_ARCH_CONST (ARCH_1 + 2)
> ...
> 
> So I think addition is more natural here than subtraction.

No, because we hit the same problem if we need more non-arch bits after
bit 9, it moves the problem, it doesn't fix it. Though admittedly, using
this level of indirection (going through ARCH_1) instead of using
constants does reduce the problem.

Yes, these bits are internal, and yes the shuffling is minimal, but we
can do better.

I'm not suggesting you need to modify your patch. I'm really just
thinking out loud. I'll take care of fixing this up later.

-- 
Matt Fleming, Intel Open Source Technology Center
