Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaCZNt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:49:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29192 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaCZNt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:49:56 -0400
Date: Wed, 26 Mar 2014 14:48:45 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Matt Fleming <matt@console-pimps.org>, david.vrabel@citrix.com,
        ian.campbell@citrix.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org, fenghua.yu@intel.com, matt.fleming@intel.com,
        tony.luck@intel.com, x86@kernel.org, tglx@linutronix.de,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, eshelton@pobox.com, mingo@redhat.com,
        linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH v3 3/5] x86: Call efi_memblock_x86_reserve_range() on
 native EFI platform only
Message-ID: <20140326134845.GN3454@olila.local.net-space.pl>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-4-git-send-email-daniel.kiper@oracle.com>
 <20140326130009.GB24856@console-pimps.org>
 <5332E2B9020000780000255D@nat28.tlf.novell.com>
 <20140326133119.GD24856@console-pimps.org>
 <5332E6AE02000078000025F0@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5332E6AE02000078000025F0@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 01:39:42PM +0000, Jan Beulich wrote:
> >>> On 26.03.14 at 14:31, <matt@console-pimps.org> wrote:
> > On Wed, 26 Mar, at 01:22:49PM, Jan Beulich wrote:
> >> >>> On 26.03.14 at 14:00, <matt@console-pimps.org> wrote:
> >> >
> >> > This could do with a little bit more explanation. Why is it not
> >> > necessary to mark the EFI memory map that was passed to the kernel as
> >> > reserved in memblock?
> >>
> >> Because that's in memory Dom0 doesn't even see: The EFI memory
> >> map is visible to the hypervisor only.
> >
> > So where does boot_params.efi_info.efi_memmap point?
> >
> > If nowhere (i.e. it's NULL) that's no problem because memblock_reserve()
> > handles zero size regions just fine.
>
> That's a question to Daniel - in our implementation (with a separate
> Xen kernel that can't run on bare hardware) boot_params as a whole
> simply doesn't exist.

On my machine this function crashes on Xen so that is why I have changed
condition. However, if you say that this issue could be solved in
another way I will investigate it further.

Daniel
