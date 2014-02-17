Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaBQTbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:31:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaBQTbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:31:07 -0500
Date: Mon, 17 Feb 2014 20:31:02 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jan Beulich <JBeulich@suse.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Issue a warning if number of present CPUs >
 maxcpus and CONFIG_HOTPLUG=n
Message-ID: <20140217203102.7af3fd28@hananiah.suse.cz>
In-Reply-To: <20140217190704.GA24390@khazad-dum.debian.net>
References: <20140215150223.63bb52fb@hananiah.suse.cz>
	<5301D7AA020000780011CBE9@nat28.tlf.novell.com>
	<20140217110402.7e4fc211@hananiah.suse.cz>
	<20140217134006.GA14786@khazad-dum.debian.net>
	<20140217151626.5ff99027@hananiah.suse.cz>
	<20140217190704.GA24390@khazad-dum.debian.net>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014 16:07:04 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Mon, 17 Feb 2014, Petr Tesarik wrote:
> > This results in:
> > 
> >   total_cpus = 1008   /* this is purely informative, it is *NOT* used
> >                          to size anything */
> >   possible = 48       /* clamped to nr_cpu_ids */
> > 
> > A warning message (with or without my patch):
> >   1024 Processors exceeds NR_CPUS limit of 48
> > 
> > Informative message:
> >   Allowing 16 CPUs, 32 hotplug CPUs
> > 
> > No other warning (with or without my patch).
> 
> I'd rather no warnings were printed at all (user asked for that nr_cpus,
> there is no reason to warn him about it),
>[...]

Agreed. This needs some cleanup.

This code used to check against NR_CPUS, which is a compile-time
constant, so the warning was printed when the user booted a kernel
incapable of using all available CPUs in the system. And this was a
good thing, because there was no (easy) way to find out this constant
from a given kernel binary.

I can post a clean-up patch that doesn't issue any warnings for user
overrides (but does issue warnings for exceeding hard-coded kernel
limits).

But I'll do it separately and only after I know if the current patch
gets accepted or not. ;-)

Petr Tesarik
