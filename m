Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaCVWED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 18:04:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:56183 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaCVWEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 18:04:00 -0400
Date: Sat, 22 Mar 2014 23:03:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Laura Abbott <lauraa@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux390@de.ibm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
In-Reply-To: <1395523881.2143.58.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.DEB.2.02.1403222302510.18573@ionos.tec.linutronix.de>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>  <1395512032-20575-2-git-send-email-lauraa@codeaurora.org> <1395523881.2143.58.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014, James Bottomley wrote:

> On Sat, 2014-03-22 at 11:13 -0700, Laura Abbott wrote:
> > Rather than have architectures #define ARCH_HAS_SG_CHAIN in an architecture
> > specific scatterlist.h, make it a proper Kconfig option and use that
> > instead. At same time, remove the header files are are now mostly
> > useless and just include asm-generic/scatterlist.h.
> 
> Well, the transformation looks fine.  Perhaps part of the reason for the
> lack of response is that there's no compelling reason in the change log
> above for doing this.  The usual reason for eliminating ARCH_HAS is that
> it's hiding something that would be better expressed a different way
> (that's actually intuitive to grep) or that it's expressing something
> that should be configurable.  Neither of these reasons apply in this
> case, because SG_CHAIN definitely is a property of the architecture not
> the config space and it's not really hiding anything.

Getting rid of pointless copied code is definitely a good enough
reason and the patch removes quite some of that.
 
Thanks,

	tglx
