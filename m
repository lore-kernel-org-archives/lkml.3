Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaBSLXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:23:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaBSLXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:23:01 -0500
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, devel@acpica.org,
        mingo@redhat.com, ck@conrad-kostecki.de, tglx@linutronix.de,
        rjw@rjwysocki.net
Subject: Re: [PATCH 1/4] ACPI: Provide support for ACPI table adding via OS
Date: Wed, 19 Feb 2014 12:22:58 +0100
Message-ID: <3327021.IBYDWO02Gb@skinner>
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <5303C7BB.4020803@zytor.com>
References: <530265A3.3020302@zytor.com> <1568883.1dLS7uNIC1@skinner> <5303C7BB.4020803@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 12:51:07 PM H. Peter Anvin wrote:
> On 02/18/2014 10:44 AM, Thomas Renninger wrote:
> > On Tuesday, February 18, 2014 10:27:23 AM H. Peter Anvin wrote:
> >> Why can't you add SSDTs? It would be particularly useful.
> > 
> > There are 2 ways how ACPI tables get added:
> >    - Via pointer from a root table (XSDT or RSDT iirc)
> >    - Via load statement inside of ACPI context when ACPI BIOS
> >    
> >      code gets executed (iirc the physical address is passed).
> > 
> > The latter is only for SSDTs.
> > The problem is that you if you add an SSDT early, it might
> > have been intended for overriding when an SSDT gets dynamically
> > loaded later when the system is up which is particular useful as
> > well if you want to debug this specific BIOS table.
> > 
> > This could be workarounded via a boot param:
> > acpi=allow_ssdt_adding
> > But this is not nice. Maybe someone has a more elegant idea.
> > Something could still be added if someone is really needing this.
> 
> Since adding SSDTs is one of the things I really can imagine one would
> do, I think we need to figure out how to do that.  I would think that
> overriding would be the exception case.

You can always paste new code into the DSDT. It is effectively the same
than adding a new SSDT table.
The other way around, modifying or deleting broken code in a BIOS
provided SSDT needs overriding.

So in fact adding SSDTs is not necessary at all.
It would be a nice add-on, but it's not even worth introducing
an extra boot param or whatever confusion.
A hint in Documentation that adding additional ASL (ACPI Source Language)
code to the DSDT would be the same than creating and adding a new
SSDT table which is not possible should be enough.

The whole thing will always taint the kernel and is meant for
debugging only anyway.

   Thomas
