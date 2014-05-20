Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaETL6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:58:33 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:53377 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaETL6b convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:2>);
	Tue, 20 May 2014 07:58:31 -0400
Message-Id: <537B5F8302000078000140F2@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Tue, 20 May 2014 12:58:27 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <ian.campbell@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <jeremy@goop.org>, <matt.fleming@intel.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <eshelton@pobox.com>, <mingo@redhat.com>, <mjg59@srcf.ucam.org>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH v4 3/5] xen: Put EFI machinery in place
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
 <537B2494.2080702@citrix.com>
 <20140520112933.GF3529@olila.local.net-space.pl>
In-Reply-To: <20140520112933.GF3529@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.05.14 at 13:29, <daniel.kiper@oracle.com> wrote:
> On Tue, May 20, 2014 at 10:47:00AM +0100, David Vrabel wrote:
>> On 16/05/14 21:41, Daniel Kiper wrote:
>> > @@ -1714,6 +1725,21 @@ asmlinkage __visible void __init xen_start_kernel(void)
>> >
>> >  	xen_setup_runstate_info(0);
>> >
>> > +	efi_systab_xen = xen_efi_probe();
>> > +
>> > +	if (efi_systab_xen) {
>> > +		strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
>> > +				sizeof(boot_params.efi_info.efi_loader_signature));
>> > +		boot_params.efi_info.efi_systab = (__u32)((__u64)efi_systab_xen);
>> > +		boot_params.efi_info.efi_systab_hi = (__u32)((__u64)efi_systab_xen >> 32);
>> > +
>> > +		x86_platform.get_wallclock = efi_get_time;
>>
>> x86_platform.get_wallclock should always be xen_get_wallclock().
> 
> Hmmm... Make sens... Jan, why did you replace x86_platform.get_wallclock
> with efi_get_time() in your implementation?

On the basis that (for Dom0 only) this is the equivalent of (and
actually also falls back to) mach_get_cmos_time(). If on Dom0
.get_wallclock doesn't get set to mach_get_cmos_time() on
pv-ops, then that line above should also be dropped.

Jan

