Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbaDWIAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:00:30 -0400
Received: from sym2.noone.org ([178.63.92.236]:43424 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbaDWIA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:00:26 -0400
Date: Wed, 23 Apr 2014 10:00:23 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Subject: Re: [PATCH 23/28] nios2: Nios2 registers
Message-ID: <20140423080023.GD1053@distanz.ch>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-20-git-send-email-lftan@altera.com>
 <20140422123914.GB1053@distanz.ch>
 <CAFiDJ5-S8bD7Z+5XcwUK_mZ+ShCMp5nj7km4NSn+Ecck3xnBxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFiDJ5-S8bD7Z+5XcwUK_mZ+ShCMp5nj7km4NSn+Ecck3xnBxQ@mail.gmail.com>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-23 at 09:10:26 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> Hi Tobias
> 
> 
> On Tue, Apr 22, 2014 at 8:39 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
> > On 2014-04-18 at 14:27:06 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> 
> >> +
> >> +/* estatus register bits */
> >> +#define ESTATUS_EPIE (1 << 0)        /* processor interrupt enable */
> >> +#define ESTATUS_EU   (1 << 1)        /* user mode */
> >> +#define ESTATUS_EH   (1 << 2)        /* Exception mode */
> >> +
> >> +/* tlbmisc register bits */
> >> +#define TLBMISC_PID_SHIFT    4
> >> +#define TLBMISC_PID_MASK     ((1UL << cpuinfo.tlb_pid_num_bits) - 1)
> >
> > You should probably #include <asm/cpuinfo.h> here since struct cpuinfo
> > is used in the definition.
> Okay, but I think we should add #ifndef __ASSEMBLY__ at #include
> <asm/cpuinfo.h> and at line #define TLBMISC_PID_MASK.
> Assembly source file might include this file as well.

Yes, makes sense.

> >
> >> +#define TLBMISC_WAY_MASK     0xf
> >> +#define TLBMISC_WAY_SHIFT    20
> >> +
> >> +#define TLBMISC_PID  (TLBMISC_PID_MASK << TLBMISC_PID_SHIFT) /* TLB PID */
> >> +#define TLBMISC_WE   (1 << 18)       /* TLB write enable */
> >> +#define TLBMISC_RD   (1 << 19)       /* TLB read */
> >> +#define TLBMISC_WAY  (TLBMISC_WAY_MASK << TLBMISC_WAY_SHIFT) /* TLB way */
> >> +
> >> +#endif /* _ASM_NIOS2_REGISTERS_H */
> 
> >>
> 
