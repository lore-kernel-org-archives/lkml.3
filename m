Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaCVVb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 17:31:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48943 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbaCVVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 17:31:24 -0400
Message-ID: <1395523881.2143.58.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux390@de.ibm.com, linux-arm-kernel@lists.infradead.org
Date: Sat, 22 Mar 2014 14:31:21 -0700
In-Reply-To: <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>
	 <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-22 at 11:13 -0700, Laura Abbott wrote:
> Rather than have architectures #define ARCH_HAS_SG_CHAIN in an architecture
> specific scatterlist.h, make it a proper Kconfig option and use that
> instead. At same time, remove the header files are are now mostly
> useless and just include asm-generic/scatterlist.h.

Well, the transformation looks fine.  Perhaps part of the reason for the
lack of response is that there's no compelling reason in the change log
above for doing this.  The usual reason for eliminating ARCH_HAS is that
it's hiding something that would be better expressed a different way
(that's actually intuitive to grep) or that it's expressing something
that should be configurable.  Neither of these reasons apply in this
case, because SG_CHAIN definitely is a property of the architecture not
the config space and it's not really hiding anything.

Perhaps now might be the time to ask which are the remaining
architectures that cannot do SG chaining and then we can fix them and
pull the whole thing out.

James


