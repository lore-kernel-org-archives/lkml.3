Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab3DZH3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:29:25 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49895 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3DZH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:29:24 -0400
Date: Fri, 26 Apr 2013 09:29:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Paul Bolle <pebolle@tiscali.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 fixes for 3.9
Message-ID: <20130426072919.GA31557@gmail.com>
References: <201304252144.r3PLihDe025383@terminus.zytor.com>
 <CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com>
 <1366928604.9976.3.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366928604.9976.3.camel@x230>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <matthew.garrett@nebula.com> wrote:

> On Thu, 2013-04-25 at 15:20 -0700, Linus Torvalds wrote:
> > On Thu, Apr 25, 2013 at 2:44 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> > >
> > > -       if (!sys_table->runtime->query_variable_info)
> > > +       if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
> > >                 return EFI_UNSUPPORTED;
> > 
> > Is a EFI 2.00 system table *guaranteed* to have that
> > "query_variable_info" function? The above adds the version check, but
> > removes the check for a NULL pointer.
> 
> As far as the spec's concerned, yes. As far as reality's concerned - if
> anything doesn't provide it, we're already crashing when
> efi_virt_query_variable_info() gets called. Nobody's complained so far.

I'm worried about the fragility of this code - this is firmware code ...

I think firmware code should be fundamentally paranoid and robust, and in 
this case treat all EFI-provided data as hostile and do a much sanity 
checking of it as possible - and provide an actionable error message if 
the checks fail, not just 'crash'.

Even if no-one complained, yet.

Thanks,

	Ingo
