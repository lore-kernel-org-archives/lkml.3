Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbaKTABT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:01:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:48314 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaKTAA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:00:58 -0500
Date: Thu, 20 Nov 2014 01:00:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CALCETrXyrk0VBbZy48nsUWnk82wFp6gpv_zw_F=3GKSDAR7T+Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411200059410.3909@nanos>
References: <20141118145234.GA7487@redhat.com> <alpine.DEB.2.11.1411181914020.3909@nanos> <20141118215540.GD35311@redhat.com> <20141119021902.GA14216@redhat.com> <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com> <20141119145902.GA13387@redhat.com>
 <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com> <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com> <20141119190215.GA10796@lerouge> <alpine.DEB.2.11.1411192251120.3909@nanos> <20141119225615.GA11386@lerouge>
 <alpine.DEB.2.11.1411200002330.3909@nanos> <CALCETrXyrk0VBbZy48nsUWnk82wFp6gpv_zw_F=3GKSDAR7T+Q@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Andy Lutomirski wrote:
> On Wed, Nov 19, 2014 at 3:09 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Sorry, I can't follow your argumentation here.
> >
> > pcpu_alloc()
> >    ....
> > area_found:
> >    ....
> >
> >         /* clear the areas and return address relative to base address */
> >         for_each_possible_cpu(cpu)
> >                 memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
> >
> > How would that memset fail to establish the mapping, which is
> > btw. already established via:
> >
> >      pcpu_populate_chunk()
> >
> > already before that memset?
> 
> I think that this will map them into init_mm->pgd and
> current->active_mm->pgd, but it won't necessarily map them into the
> rest of the pgds.

And why would mapping them into the kernel mapping, i.e. init_mm not
be sufficient?

We are talking about kernel memory and not some random user space
mapping.

Thanks,

	tglx
