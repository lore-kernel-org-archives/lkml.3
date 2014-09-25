Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaIYKel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:34:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56637 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbaIYKej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:34:39 -0400
Date: Thu, 25 Sep 2014 11:33:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 09/17] m68k: io: implement dummy relaxed accessor
 macros for writes
Message-ID: <20140925103337.GH20043@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
 <1411579056-16966-10-git-send-email-will.deacon@arm.com>
 <54236A67.90001@uclinux.org>
 <20140925093309.GG20043@arm.com>
 <CAMuHMdVpCs2RtsdDpdN3tp9_Xa1TzDMM3Z5+pP07B7Y3He2hLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVpCs2RtsdDpdN3tp9_Xa1TzDMM3Z5+pP07B7Y3He2hLA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 10:51:10AM +0100, Geert Uytterhoeven wrote:
> On Thu, Sep 25, 2014 at 11:33 AM, Will Deacon <will.deacon@arm.com> wrote:
> >> Putting them here means they won't have any multiple include protection
> >> (there is no "#ifndef _IO_H" around them). Doesn't seem to lead to
> >> any problems in practice. Just flagging it...
> >
> > That's easy enough to fix, and actually, we should have __KERNEL__ checks
> > here too. Fixup below.
> 
> Why do we need __KERNEL__ checks? <asm/io.h> is not exported.
> BTW, it seems there are many __KERNEL__ checks in arch/*/include/asm/
> we don't need.
> 
> Or do I need more coffee?

No, I think you're quite right. I just saw the __KERNEL__ checks in io_no.h
and io_mm.h -- the latter even has some code outside of the guards:


#endif /* __KERNEL__ */

#define __ARCH_HAS_NO_PAGE_ZERO_MAPPED		1

/*
 * Convert a physical pointer to a virtual kernel pointer for /dev/mem
 * access
 */
#define xlate_dev_mem_ptr(p)	__va(p)

/*
 * Convert a virtual cached pointer to an uncached pointer
 */
#define xlate_dev_kmem_ptr(p)	p

#define ioport_map(port, nr)	((void __iomem *)(port))

#endif /* _IO_H */


Will
