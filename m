Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaG3HNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:13:14 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:47203 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbaG3HNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:13:11 -0400
Date: Wed, 30 Jul 2014 09:13:08 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of
 load_balance()  in scheduler
Message-ID: <20140730071308.GF22904@x4>
References: <20140730014827.565626091@linuxfoundation.org>
 <20140730014829.344302554@linuxfoundation.org>
 <20140730065312.GA1652@laptop.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730065312.GA1652@laptop.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.07.30 at 08:53 +0200, Jakub Jelinek wrote:
> On Tue, Jul 29, 2014 at 06:49:09PM -0700, Greg Kroah-Hartman wrote:
> > 3.15-stable review patch.  If anyone has any objections, please let me know.
> 
> IMNSHO this is a too big hammer approach.  The bug happened on a single
> file only (right?), so if anything, IMHO it could be disabled for that
> single file only, and better do it only for compilers with the bug.

No. There are many more files affected. It just happens that Linus
analyzed the assembly of this single file (fair.c) and found a bug. 
Just build your redhat distro kernel with GCC_COMPARE_DEBUG=1 and you'll
see. So unless someone analyzes the assembly output of all other
affected files by hand and finds no issues, one has to assume the worst.

> If there are wrong code bugs with -O2 (we've fixed many in the past), you
> also don't turn off -O2 everywhere, similarly for -Os or any other options.
> Disabling it just in case the same bug happens elsewhere when it actually
> took 5 years before the bug caused miscompilation of something is too
> defensive.  We had at least 15 other wrong-code bugfixes just in between
> 4.9.0 and 4.9.1.  -fvar-tracking-assignments doesn't make a small difference
> in debug info, but significant for optimized code.
> If you build the kernel without and with -fno-var-tracking-assignments,
> you can use e.g. the dwlocstat tool to see what kind of difference it makes
> for the kernel in particular in variable debug info coverage.

I'm sure it would be possible to backport a proper check based on the
gcc testcase to the stable kernels, once it gets implemented.

-- 
Markus
