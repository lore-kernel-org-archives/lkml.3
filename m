Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbaJNVku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:40:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaJNVkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:40:49 -0400
Date: Tue, 14 Oct 2014 14:40:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Riku Voipio <riku.voipio@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gcov: add ARM64 to GCOV_PROFILE_ALL
Message-Id: <20141014144048.e2bf1f5ec23c39d2a59700f6@linux-foundation.org>
In-Reply-To: <543694F4.3070306@linux.vnet.ibm.com>
References: <1412852099-23099-1-git-send-email-riku.voipio@linaro.org>
	<543694F4.3070306@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Oct 2014 16:00:20 +0200 Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> Looks good. Andrew, can you pick this change up via your tree?
> 

Sure.

> 
> On 09.10.2014 12:54, Riku Voipio wrote:
> > Following up the arm testing of gcov, turns out gcov on ARM64
> > works fine as well. Only change needed is adding ARM64 to Kconfig
> > depends.
> > 
> > Tested with qemu and mach-virt
> > 
> > Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
> > ---
> >  kernel/gcov/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
> > index cf66c5c..3b74087 100644
> > --- a/kernel/gcov/Kconfig
> > +++ b/kernel/gcov/Kconfig
> > @@ -35,7 +35,7 @@ config GCOV_KERNEL
> >  config GCOV_PROFILE_ALL
> >  	bool "Profile entire Kernel"
> >  	depends on GCOV_KERNEL
> > -	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM
> > +	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM || ARM64
> >  	default n
> >  	---help---
> >  	This options activates profiling for the entire kernel.

gcov is doing this the wrong way.  There should be a `select
GCOV_PROFILE_ALL' in each arch/*/Kconfig.

(But pleeeeeeze not at the end of the list!  That's the perfect way of
maximizing patch conflicts, but nobody seems to understand this)
