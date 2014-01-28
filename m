Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaA1KdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:33:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbaA1KdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:33:04 -0500
Date: Tue, 28 Jan 2014 11:33:03 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>,
        Michael Matz <matz@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [RFC] x86: Disable traditional FPU instructions too
Message-ID: <20140128103303.GE2221@dhcp22.suse.cz>
References: <20140127163758.GC6839@pd.tnic>
 <52E68C25.1070804@zytor.com>
 <20140127164544.GE6839@pd.tnic>
 <20140128093701.GC2221@dhcp22.suse.cz>
 <30d5350d-2f0d-4103-a28d-cb9b796fd8ce@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30d5350d-2f0d-4103-a28d-cb9b796fd8ce@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28-01-14 02:25:09, H. Peter Anvin wrote:
> If that is intentional it needs a big huge freaking comment recording
> why it is not a bug. 

Agreed.

> I would expect that to generate a FP multiply.

Exactly! And actually the very same construct in a module provided to
reproduce an issue was a trigger to the discussed patch.

> On January 28, 2014 1:37:01 AM PST, Michal Hocko <mhocko@suse.cz> wrote:
> >[CCing Ralf for MIPS.]
> >
> >On Mon 27-01-14 17:45:44, Borislav Petkov wrote:
> >> On Mon, Jan 27, 2014 at 08:41:09AM -0800, H. Peter Anvin wrote:
> >> > I don't think it'd hurt... although I think the above pretty much
> >> > requires that the code contain actual floating-point types to ever
> >be
> >> > generated.
> >> 
> >> Yes, that is supposed to catch usage of the 'E' floating constant,
> >for
> >> example, in definitions. It is a build-time assertion, if you want.
> >:)
> >
> >And git grep says that mips abuses this notation:
> >arch/mips/include/asm/kvm_host.h:#define MS_TO_NS(x) (x * 1E6L)
> >
> >I do not have cross-compiler set up to check whether this is a real
> >issue because include/media/rc-core.h defines the same macro correctly
> >so the real code might end up using the right variant.
> 
> -- 
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.

-- 
Michal Hocko
SUSE Labs
