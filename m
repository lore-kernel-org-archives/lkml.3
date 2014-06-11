Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaFKTVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:21:17 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:41206 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaFKTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:21:16 -0400
Date: Wed, 11 Jun 2014 21:21:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-arch@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC 00/10] tools: Revamp the unaligned endian access
 functions
Message-ID: <20140611192111.GB16069@ravnborg.org>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 04:13:04PM -0700, H. Peter Anvin wrote:
> After a recent problem in the x86 tree, which seems to be the heaviest
> but not the only user of these functions, I went through and did a
> patchset to revamp the *user space* unaligned/endian accessor
> functions.  As much as I think it is downright pathetic that this
> functionality still isn't part of the C standard, that is life and we
> have to deal with it.  Furthermore, although glibc has a pretty nice
> set of functions for byte swapping in <endian.h>, taken from FreeBSD I
> believe, some older systems don't support them.
> 
> This variant tries to fill in all the holes.  It assumes that
> <endian.h> define the functions as macros if they exist, as I don't
> know any other way of probing for them without reaching for autoconf,
> but that should be valid enough of an assumption in this case.
> 
> The hope is that this should give reasonable, if not optimal, code
> generation on most processors, and give a hook where arch maintainers
> can add their own changes if needed.

This looks like a very complex solution to a simple problem.
We want a shared implementation of the *user space*
unaligned/endian accessor functions.
But do we really want *fast* versions for our use?

This is not a new libc that should generate optimal code,
but only something were we want to provide e working
implmentation for use in our user-space tools.

A much simpler approach without any fallback to arch specific
version etc. is everything we need.

	Sam

