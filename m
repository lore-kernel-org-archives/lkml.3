Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3AKSY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:24:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab3AKSYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:24:54 -0500
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org,
        horms@verge.net.au
Subject: Re: [PATCH] x86 e820: only void usable memory areas in memmap=exactmap case
Date: Fri, 11 Jan 2013 19:24:41 +0100
Message-ID: <1603289.LXteBtkifD@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQWPJdER++ZrkKx7cQpF0QvwBeghNjpFqK18pMNC0w20tw@mail.gmail.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <201301111333.49238.trenn@suse.de> <CAE9FiQWPJdER++ZrkKx7cQpF0QvwBeghNjpFqK18pMNC0w20tw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 08:16:52 AM Yinghai Lu wrote:
> On Fri, Jan 11, 2013 at 4:33 AM, Thomas Renninger <trenn@suse.de> wrote:
...
> > -               e820.nr_map = 0;
> > +               /*
> > +                * Remove all usable memory (this is for kdump), usable
> > +                * memory will be passed via memmap=X@Y parameter
> > +                */
> > +               e820_remove_range_type(E820_RAM);
> 
> We may need to keep exactmap intact.
Why?
Kexec/kdump should have been the only user?
If older/current kexec calls still add ACPI maps via memmap=X#Y,
they should already exist in the original e820 map and fall off or
get glued to one region if (wrongly) overlapping via sanitize_map.
 
> but could add another one like exact_ram_map
> or extend to have memmap=exactmap=ram or etc.

I would avoid that if anyhow possible because then you run into
kexec vs kernel version problems.

Maybe I should explicitly post (out of this thread) the patch to the
kexec list.
If nobody can come up with a strong reason, it should be ok?

   Thomas
