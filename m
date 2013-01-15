Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3AOAzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:55:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab3AOAzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:55:06 -0500
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Subject: Re: [PATCH] x86 e820: only void usable memory areas in memmap=exactmap case
Date: Tue, 15 Jan 2013 01:54:55 +0100
Message-ID: <1824463.EWDqkMLC4N@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQVQvj1TPokoCgx_jbp0VACC8cgtFibH4KoqOssEc6JSPw@mail.gmail.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <201301141605.43428.trenn@suse.de> <CAE9FiQVQvj1TPokoCgx_jbp0VACC8cgtFibH4KoqOssEc6JSPw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 14, 2013 11:04:36 AM Yinghai Lu wrote:
> On Mon, Jan 14, 2013 at 7:05 AM, Thomas Renninger <trenn@suse.de> wrote:
> > What is this for?:
> > @@ -871,6 +879,11 @@ static int __init parse_memmap_one(char
> > 
> >         userdef = 1;
> >         if (*p == '@') {
> >         
> >                 start_at = memparse(p+1, &p);
> > 
> > +               if (exactusablemap_parsed) {
> > +                       /* remove all range with other types */
> > +                       e820_remove_range(start_at, mem_size,
> > +                                                E820_RAM, 0);
> > +               }
> > 
> >                 e820_add_region(start_at, mem_size, E820_RAM);
> >         
> >         } else if (*p == '#') {
> >         
> >                 start_at = memparse(p+1, &p);
> 
> remove all old renges before add E820_RAM, otherwise new add E820
> ranges could be ignored.
But this is intended?
kexec must never request reserved memory to be used as ordinary E820_RAM
by the kdump kernel.
This also reverts what exactusablemap is all about:
Keep all reserved memory ranges of the original BIOS map.

Above would again wrongly remove the mmconf and other reserved regions
if kexec passes memmap=exactuseablemap,x@y

>From what I can see the patch looks fine, but above part should
simply be left out.

   Thomas
