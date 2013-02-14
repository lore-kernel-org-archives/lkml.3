Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589Ab3BNTMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:12:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44727 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965083Ab3BNTMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:12:46 -0500
Date: Thu, 14 Feb 2013 20:12:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jslaby@suse.cz>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130214191234.GH5700@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
	x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20130129202848.GE25415@pd.tnic>
 <3066730.6MVSAfNyye@vostro.rjw.lan>
 <20130131131034.GF4926@pd.tnic>
 <2293454.v8QRHr8txR@vostro.rjw.lan>
 <20130203144656.GB5844@pd.tnic>
 <20130214143905.GC5700@pd.tnic>
 <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 10:17:46AM -0700, Bjorn Helgaas wrote:
> On Thu, Feb 14, 2013 at 7:39 AM, Borislav Petkov <bp@suse.de> wrote:
> > On Sun, Feb 03, 2013 at 03:46:56PM +0100, Borislav Petkov wrote:
> >> On Sun, Feb 03, 2013 at 12:04:46AM +0100, Rafael J. Wysocki wrote:
> >> > The [2/5] is at: https://patchwork.kernel.org/patch/2001211/
> >> >
> >> > The other two are attached.  I suppose the ordering doesn't matter.
> >>
> >> Ok, the eth link cable hotplugging issue seems fixed, plugging and
> >> unplugging the cable works as expected.
> >
> > Q: what happened to those, are they going upstream for 3.9 or are you
> > sending them now for 3.8?
> >
> > They fix at least the cable hotplugging issue so at least one thing is
> > covered.
> 
> I haven't done anything with the e1000e patches; I assume the e1000e
> maintainers will take care of those.
> 
> I merged the following patches for v3.9:
> 
>     * pci/konstantin-runtime-pm:
>       PCI/PM: Clear state_saved during suspend
>       PCI: Use atomic_inc_return() rather than atomic_add_return()
>       PCI: Catch attempts to disable already-disabled devices
>       PCI: Disable Bus Master unconditionally in pci_device_shutdown()
> 
> You can see the actual patches I merged at:
> http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=shortlog;h=refs/heads/next
> 
> It's pretty late for v3.8, but let me know if you think they're critical.

Ok, I meant those:

http://marc.info/?l=linux-kernel&m=135984592927219

They fix the link detection issue on my x230. So let's see. The first one is:

* https://patchwork.kernel.org/patch/2001211/ (e1000e: fix pci device enable
counter balance)

Rafael said this one is a real bugfix. Looks like e1000e maintainers are
picking that one?

* pci-pm-fix-e1000e-runtime-suspend.patch

I don't see that one in your tree.

* pci-pm-clear-state_saved-during-suspend.patch

I can see this one in your tree: http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commitdiff;h=82fee4d67ab86d6fe5eb0f9a9e988ca9d654d765

With the imminence of the 3.8 release, we probably want to wait for
after the merge window and retest again, then apply and packport stuff,
if needed.

And the NMI issue is still unfixed so this needs more work, AFAICT. Oh
well, after the merge window.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
