Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaERSS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 14:18:27 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:45884 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaERSSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 14:18:24 -0400
Date: Sun, 18 May 2014 18:18:16 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arnd Bergmann <arnd@arndb.de>, Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <5378DB83.1000406@zytor.com>
Message-ID: <Pine.LNX.4.64.1405181801130.4608@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <4706636.rTYoqSXXOR@wuerfel> <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk>
 <9236147.lyD24Zv5SZ@wuerfel> <53769B27.2090407@zytor.com>
 <Pine.LNX.4.64.1405162336150.24114@digraph.polyomino.org.uk> <5376AE23.10905@zytor.com>
 <Pine.LNX.4.64.1405181325520.4608@digraph.polyomino.org.uk> <5378DB83.1000406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 18 May 2014 18:18:19.0905 (UTC) FILETIME=[8BF1FF10:01CF72C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2014, H. Peter Anvin wrote:

> This potentially requires the kernel to maintain three separate ABIs if
> there is a legacy 32-bit ABI, which is quite frankly idiotic.  You seem

Three ABIs seems reasonable enough to me where appropriate.

> to be thinking of POSIX as something handed down by gods, which it
> isn't... quite frankly they did something stupid here and should fix
> their own mess.

In the real world it's useful to support lots of different standard 
versions, not just some hypothetical future version (I see no evidence of 
anyone thinking there is a POSIX defect actually having raised the issue 
with the Austin Group to see if anyone there agrees a change would be 
useful).  We've only just removed support for _BSD_SOURCE / _SVID_SOURCE 
as defined API levels from glibc; I'd guess it will be about 20 years 
before removing support for POSIX.1-2008/2013 is appropriate (even if the 
next major edition relaxes this requirement).

> As far as glibc is concerned, this would require glibc to intercept each
> ioctl, which is completely infeasible... struct timespec/timeval is
> embedded far too deep everywhere.

Well, maybe the subset of applications passing timespec to ioctls should 
carry the cost of converting from the userspace timespec to the kernel 
timespec, rather than POSIX applications carrying the cost of unnecessary 
incompatibility.  (But an enumeration of the relevant ioctls is needed 
anyway simply to provide new versions of them all for 64-bit time_t.)

-- 
Joseph S. Myers
joseph@codesourcery.com
