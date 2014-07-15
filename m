Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbaGOXTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:19:46 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:16601 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbaGOXTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:19:42 -0400
X-Greylist: delayed 12894 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 19:19:42 EDT
Message-ID: <1405465801.28702.34.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH 3/11] x86, mm, pat: Change reserve_memtype() to
 handle WT type
From: Toshi Kani <toshi.kani@hp.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>
Date: Tue, 15 Jul 2014 17:10:01 -0600
In-Reply-To: <CALCETrUPpP1Lo1gB_eTm6V3pJ3Fam-1gPZGKfksOXXGgtNGsEQ@mail.gmail.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
	 <1405452884-25688-4-git-send-email-toshi.kani@hp.com>
	 <CALCETrUPpP1Lo1gB_eTm6V3pJ3Fam-1gPZGKfksOXXGgtNGsEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 12:56 -0700, Andy Lutomirski wrote:
> On Tue, Jul 15, 2014 at 12:34 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > This patch changes reserve_memtype() to handle the new WT type.
> > When (!pat_enabled && new_type), it continues to set either WB
> > or UC- to *new_type.  When pat_enabled, it can reserve a given
> > non-RAM range for WT.  At this point, it may not reserve a RAM
> > range for WT since reserve_ram_pages_type() uses the page flags
> > limited to three memory types, WB, WC and UC.
> 
> FWIW, last time I looked at this, it seemed like all the fancy
> reserve_ram_pages stuff was unnecessary: shouldn't the RAM type be
> easy to track in the direct map page tables?

Are you referring the direct map page tables as the kernel page
directory tables (pgd/pud/..)?

I think it needs to be able to keep track of the memory type per a
physical memory range, not per a translation, in order to prevent
aliasing of the memory type.

Thanks,
-Toshi

