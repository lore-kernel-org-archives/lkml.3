Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaGOP4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:56:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28427 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaGOP4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:56:25 -0400
Date: Tue, 15 Jul 2014 11:56:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] x86_64,xen,espfix: Initialize espfix on secondary CPUs
Message-ID: <20140715155619.GC7792@laptop.dumpdata.com>
References: <195642a5e9fd4515ad8ca4cd8bcffd4900df5790.1405437568.git.luto@amacapital.net>
 <20140715153801.GX3403@laptop.dumpdata.com>
 <CALCETrUsjMkQfwhwAvsJz0gNXaH-OOz0qCUJ5q1me3=4zpP7Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUsjMkQfwhwAvsJz0gNXaH-OOz0qCUJ5q1me3=4zpP7Ew@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 08:44:39AM -0700, Andy Lutomirski wrote:
> On Tue, Jul 15, 2014 at 8:38 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Tue, Jul 15, 2014 at 08:26:41AM -0700, Andy Lutomirski wrote:
> >> Xen doesn't call start_secondary.
> >
> > Duh!
> >>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> ---
> >>
> >> espfix still doesn't seem to work on Xen (it goes boom in some way that
> >> I don't understand right now), but initializing all CPUs instead of just
> >> one of them seems like a good start.
> >>
> >> ISTM the right fix is probably to shove the espfix logic into
> >> native_iret and to tweak the paravirt logic so that native_iret always
> >> gets invoked.  I suspect that Xen will need its own implementation of
> >> espfix64 in the hypervisor and that, ultimately, someone may want to
> >> stop initializing espfix64 at all on Xen guests.
> >
> > I think just disallowing would be preferrable.
> 
> Disabling what?
> 
> Sorry, my flu-addled brain needs more clarity.  I'm currently working
> on a patch on top of this one to move all of the espfix64 invocation
> logic into native_iret, which will have the effect of preventing it
> from being used on Xen.
> 
> Is that what you mean?

Yes. I presume the logic to deal with the bits losing information
has to be dealt in the Xen case somehow. Peter asked whether the 
Xen IRET handles a 16-bit stack segment - and if it restores all of the
RSP then we are OK.

I don't have yet that information and my brain is a in low-power right
now (-ENOSLEEP).
