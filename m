Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaCZNjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:39:47 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49048 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaCZNjp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:3>);
	Wed, 26 Mar 2014 09:39:45 -0400
Message-Id: <5332E6AE02000078000025F0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 26 Mar 2014 13:39:42 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt@console-pimps.org>
Cc: <david.vrabel@citrix.com>, <ian.campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        <fenghua.yu@intel.com>, <matt.fleming@intel.com>,
        <tony.luck@intel.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>, <konrad.wilk@oracle.com>,
        <eshelton@pobox.com>, <mingo@redhat.com>, <linux-efi@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH v3 3/5] x86: Call efi_memblock_x86_reserve_range()
 on native EFI platform only
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-4-git-send-email-daniel.kiper@oracle.com>
 <20140326130009.GB24856@console-pimps.org>
 <5332E2B9020000780000255D@nat28.tlf.novell.com>
 <20140326133119.GD24856@console-pimps.org>
In-Reply-To: <20140326133119.GD24856@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.03.14 at 14:31, <matt@console-pimps.org> wrote:
> On Wed, 26 Mar, at 01:22:49PM, Jan Beulich wrote:
>> >>> On 26.03.14 at 14:00, <matt@console-pimps.org> wrote:
>> > 
>> > This could do with a little bit more explanation. Why is it not
>> > necessary to mark the EFI memory map that was passed to the kernel as
>> > reserved in memblock?
>> 
>> Because that's in memory Dom0 doesn't even see: The EFI memory
>> map is visible to the hypervisor only.
> 
> So where does boot_params.efi_info.efi_memmap point?
> 
> If nowhere (i.e. it's NULL) that's no problem because memblock_reserve()
> handles zero size regions just fine.

That's a question to Daniel - in our implementation (with a separate
Xen kernel that can't run on bare hardware) boot_params as a whole
simply doesn't exist.

Jan

