Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaCZOIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:08:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41700 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaCZOIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:08:35 -0400
Date: Wed, 26 Mar 2014 15:08:00 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, jeremy@goop.org,
        fenghua.yu@intel.com, matt.fleming@intel.com, tony.luck@intel.com,
        x86@kernel.org, tglx@linutronix.de, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com, eshelton@pobox.com,
        mingo@redhat.com, linux-efi@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH v3 2/5] efi: Export arch_tables variable
Message-ID: <20140326140800.GP3454@olila.local.net-space.pl>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-3-git-send-email-daniel.kiper@oracle.com>
 <5332E25F020000780000255A@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5332E25F020000780000255A@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 01:21:19PM +0000, Jan Beulich wrote:
> >>> On 25.03.14 at 21:57, <daniel.kiper@oracle.com> wrote:
> > Export arch_tables variable. Xen init function calls efi_config_init()
> > which takes it as an argument.
> >
> > Additionally, put __initdata in place suggested by include/linux/init.h.
>
> Which isn't necessarily the most appropriate place.

Why? If comments in include/linux/init.h are not valid they should be changed.

> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -70,7 +70,7 @@ static efi_system_table_t efi_systab __initdata;
> >
> >  unsigned long x86_efi_facility;
> >
> > -static __initdata efi_config_table_type_t arch_tables[] = {
> > +efi_config_table_type_t arch_tables[] __initdata = {
>
> efi_config_table_type_t __initdata arch_tables[] = {
>
> would be what I'd recommend.
>
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -583,6 +583,8 @@ extern struct efi {
> >  	struct efi_memory_map *memmap;
> >  } efi;
> >
> > +extern efi_config_table_type_t arch_tables[] __initdata;
>
> And section placement annotations are bogus on declarations.

Hmmm... I am not sure which approach is better. I saw that
in many places declarations have annotations. Could you
point me some docs which states (and explains) that this
is wrong idea.

Daniel
