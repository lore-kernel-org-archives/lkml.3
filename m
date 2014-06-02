Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaFBK6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:58:21 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56706 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFBK6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:58:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 12:56:42 +0200
Message-ID: <4178301.j9kWdGCRLC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <8618458.1EVJCoVbkH@wuerfel> <alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rc5WLQ/9j2qpMfwTsA0d0sLxGYtDN5Q90L7frf+Bkjc
 z7o7Ihk6Zig4bOCe3nDbDr8m1/GKHG9dL4ig8bggV4tUvPsW2n
 Wk1oolEllkgTXtYCEe9Iqj78J4EyLAdHt07DJKHkD4Gbqn8Ov6
 SF4zQ2pA4F7poZBUHQuPhuuefpWtjJZ+mGUjUb7erpRcRLf/E9
 uU5WD09126Dm3iPlY+1IrJL/2rM1HU77Vu0MDmNwy2MZ+mv6kH
 q7+TnOAWSFHDuGTWHswv6GoEDEtPRhThbh0gzGvin06XigZbnP
 ZYkjpKorAHKj1A+88kfEHLibIWL/CPvfQFqLFBm5b57zT2mpMK
 kboML90cXK+9Of5S7Ih8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2014 21:36:26 Nicolas Pitre wrote:
> 
> > For actually running kernels beyond 2038, the best idea I've seen so
> > far is to disallow all broken code at compile time. I don't see
> > a choice but to audit the entire kernel for invalid uses on both
> > 32 and 64 bit in the next few years. A lot of code will get changed
> > in the process so we can actually keep running 32-bit kernels and
> > file systems, but other code will likely go away:
> > 
> > * any system calls that pass a time_t, timeval or timespec on
> >   32-bit systems return -ENOSYS, to ensure all user land uses
> >   the replacements we will put into place
> > * The definition of 'time_t', 'timval' and 'timespec' can be hidden
> >   from the kernel, and all code using it left out.
> > * ext2 and ext3 file system code will have to be disabled, but that's
> >   file since ext4 can mount old file systems.
> 
> Syscalls and libs can be "fixed".  Existing filesystem content might 
> not.  So if you need to mount some old media in read-write mode after 
> 2038 and that happens to content an ext2 or similarly limited filesystem 
> then it'd better just "work".  Having the kernel refuse to modify the 
> filesystem would be unacceptable.

I think you misunderstood what I suggested: the intent is to avoid
seeing things break in 2038 by making them break much earlier. We have
a solution for ext2 file systems, it's called ext4, and we just need
to ensure that everybody knows they have to migrate eventually.

At some point before the mid 2030ies, you should no longer be able to
build a kernel that has support for ext2 or any other module that will
run into bugs later. Until then (rather sooner than later), I'd like
to get to the point where you can choose whether to include those
modules at build time or not, and then get everybody to turn off that
option and fix the bugs they run into. You wouldn't need that for a
2014-generation long-term support disto (rhel 7, sles 12, debian 7,
ubuntu 14.04, ...), but perhaps for the next generation, or the
one after that.

	Arnd
