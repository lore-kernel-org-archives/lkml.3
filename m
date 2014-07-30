Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaG3HVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:21:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbaG3HVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:21:35 -0400
Date: Wed, 30 Jul 2014 09:21:20 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of
 load_balance()  in scheduler
Message-ID: <20140730072120.GB1652@laptop.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20140730014827.565626091@linuxfoundation.org>
 <20140730014829.344302554@linuxfoundation.org>
 <20140730065312.GA1652@laptop.redhat.com>
 <20140730071308.GF22904@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730071308.GF22904@x4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 09:13:08AM +0200, Markus Trippelsdorf wrote:
> On 2014.07.30 at 08:53 +0200, Jakub Jelinek wrote:
> > On Tue, Jul 29, 2014 at 06:49:09PM -0700, Greg Kroah-Hartman wrote:
> > > 3.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > IMNSHO this is a too big hammer approach.  The bug happened on a single
> > file only (right?), so if anything, IMHO it could be disabled for that
> > single file only, and better do it only for compilers with the bug.
> 
> No. There are many more files affected. It just happens that Linus
> analyzed the assembly of this single file (fair.c) and found a bug. 
> Just build your redhat distro kernel with GCC_COMPARE_DEBUG=1 and you'll
> see. So unless someone analyzes the assembly output of all other
> affected files by hand and finds no issues, one has to assume the worst.

I'm talking about wrong-code issues.  For -fcompare-debug, we indeed check
it primarily during gcc bootstrap (through bootstrap-debug) and some
testcases, and we'll certainly try to build some more code with
-fcompare-debug and fix the issues.

	Jakub
