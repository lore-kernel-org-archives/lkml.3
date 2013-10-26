Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3JZCUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 22:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab3JZCUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 22:20:31 -0400
Message-ID: <1382754015.19471.80.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
From: Adam Williamson <awilliam@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Lan Tianyu <tianyu.lan@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Peter Anvin <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, Robin Holt <holt@sgi.com>,
        davej@fedoraproject.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 25 Oct 2013 19:20:15 -0700
In-Reply-To: <1382750841.19471.72.camel@adam.happyassassin.net>
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com>
	 <20131025105352.GA5419@gmail.com>
	 <1382719652.2445.1.camel@adam.happyassassin.net>
	 <CA+55aFyZEZp3CSFEcxzKt0c_7Q9_juGWiqb7VH214Fjcs3wUkQ@mail.gmail.com>
	 <1382750841.19471.72.camel@adam.happyassassin.net>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 18:27 -0700, Adam Williamson wrote:
> On Fri, 2013-10-25 at 18:16 +0100, Linus Torvalds wrote:
> > On Fri, Oct 25, 2013 at 5:47 PM, Adam Williamson <awilliam@redhat.com> wrote:
> > >
> > > I don't, but one comment I could add is that reboot _used_ to work okay
> > > on the Z1. And I _think_ it's worked OK since the April 2011 commit you
> > > mention (so the introduction of that didn't break it), but I can't
> > > absolutely swear to it.
> > 
> > It might be interesting to try, and if it used to work with the acpi
> > method, use bisection to see when it stopped working..
> 
> So I might have trouble bisecting, as stone-age kernels don't seem to
> boot on my installed system cleanly any more; some kind of
> incompatibility with my encrypted partitions. But I booted an F16 live
> image, which has kernel 3.1.0, and that reboots quickly. If I'm reading
> things correctly, mjg59's patch went into kernel 2.6.39, so if that was
> causing the problem, I'd expect the F16 live image to have a slow
> reboot.
> 
> I'll go back through the live images for F17->F19 and see when the
> reboot gets slow, which will give us a very rough range to look at, at
> least. I'll also try Rafael's suggestion re acpi_osi.

OK, so, findings: F16 and F17 live images reboot quickly. F18 is the
first that reboots slowly. That gives us a range of
kernel-3.3.4-5.fc17.x86_64.rpm  (the F17 release kernel - last known
good) to kernel-3.6.10-4.fc18.x86_64.rpm (the F18 release kernel - first
known bad). I'll try and see if I can find a way to narrow the range
any. Well, one report on the vaio-z mailing list -
https://lists.launchpad.net/sony-vaio-z-series/msg02868.html - indicates
the problem existed in Ubuntu kernel 3.5.0-17-generic , so that'd be a
range of 3.3.4 to 3.5.0 for the breakage.

acpi_osi="!Windows 2012" as a kernel parameter on a 3.12-rc6 kernel does
not result in a fast reboot, it's no help.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

