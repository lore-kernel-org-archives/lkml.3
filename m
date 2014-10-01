Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaJAMmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:42:43 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40061 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJAMmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:42:42 -0400
Date: Wed, 1 Oct 2014 13:42:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "pinskia@gmail.com" <pinskia@gmail.com>,
        Andrew Pinski <apinski@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/24] Allow a 32bit ABI to use the naming of the 64bit
 ABI syscalls to avoid confusion of not splitting the registers
Message-ID: <20141001124226.GI12702@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
 <1409779158-30963-9-git-send-email-apinski@cavium.com>
 <3318813.yqP9pCQtAB@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3318813.yqP9pCQtAB@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:11:04AM +0100, Arnd Bergmann wrote:
> On Wednesday 03 September 2014 14:19:02 Andrew Pinski wrote:
> > + * For 32bit abis where 64bit can be passed via one
> > + * register, use the same naming as the 64bit ones
> > + * as they will only have a 64 bit off_t.
> >   */
> > -#if __BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)
> > +#if (__BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)) || \
> > +       defined(__ARCH_WANT_64BIT_SYSCALLS)
> 
> I'm not sure if __ARCH_WANT_64BIT_SYSCALLS is the best name for
> this, since it's really only about off_t. It took me a while
> to understand what you are doing here.

I'm not sure I fully get it yet. So with this change, we avoid using
syscall numbers like __NR_ftruncate64 in favour of __NR_ftruncate. Why?
(maybe there's a valid reason, just not getting it).

Either way, ILP32 would still end up calling sys_ftruncate64() (rather
than the native sys_ftruncate()).

-- 
Catalin
