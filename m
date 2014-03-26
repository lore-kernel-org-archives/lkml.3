Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaCZNb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:31:28 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:52177 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbaCZNbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:31:24 -0400
Date: Wed, 26 Mar 2014 13:31:19 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, jeremy@goop.org,
        fenghua.yu@intel.com, matt.fleming@intel.com, tony.luck@intel.com,
        x86@kernel.org, tglx@linutronix.de, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, Daniel Kiper <daniel.kiper@oracle.com>,
        konrad.wilk@oracle.com, eshelton@pobox.com, mingo@redhat.com,
        linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH v3 3/5] x86: Call efi_memblock_x86_reserve_range() on
 native EFI platform only
Message-ID: <20140326133119.GD24856@console-pimps.org>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-4-git-send-email-daniel.kiper@oracle.com>
 <20140326130009.GB24856@console-pimps.org>
 <5332E2B9020000780000255D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5332E2B9020000780000255D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar, at 01:22:49PM, Jan Beulich wrote:
> >>> On 26.03.14 at 14:00, <matt@console-pimps.org> wrote:
> > 
> > This could do with a little bit more explanation. Why is it not
> > necessary to mark the EFI memory map that was passed to the kernel as
> > reserved in memblock?
> 
> Because that's in memory Dom0 doesn't even see: The EFI memory
> map is visible to the hypervisor only.

So where does boot_params.efi_info.efi_memmap point?

If nowhere (i.e. it's NULL) that's no problem because memblock_reserve()
handles zero size regions just fine.

-- 
Matt Fleming, Intel Open Source Technology Center
