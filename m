Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab3GDXxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 19:53:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48792 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159Ab3GDXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 19:53:17 -0400
Date: Fri, 5 Jul 2013 00:53:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>,
        Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/3] arch/um/Makefile: remove dead code
Message-ID: <20130704235313.GP4165@ZenIV.linux.org.uk>
References: <1372971797-23518-1-git-send-email-artagnon@gmail.com>
 <1372971797-23518-2-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372971797-23518-2-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 02:33:15AM +0530, Ramkumar Ramachandra wrote:
> arch/um/Makefile is included in the toplevel Makefile:495.  Well before
> that, it unconditionally sets $SUBARCH (in Makefile:168) as follows:
> 
>   SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
> 				    -e s/sun4u/sparc64/ \
> 				    -e s/arm.*/arm/ -e s/sa110/arm/ \
> 				    -e s/s390x/s390/ -e s/parisc64/parisc/ \
> 				    -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> 				    -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
> 
> It is clearly impossible for $SUBARCH to be set as i386 or x86_64.

RTFM(make); section 9.5 in GNU make info, or the following from POSIX:

[quote]

Macro definitions shall be taken from the following sources, in the following
logical order, before the makefile(s) are read.

   1.  Macros specified on the make utility command line, in the order
specified on the command line. It is unspecified whether the internal macros
defined in Internal Macros are accepted from this source.
   2.  Macros defined by the MAKEFLAGS environment variable, in the order
specified in the environment variable. It is unspecified whether the internal
macros defined in Internal Macros are accepted from this source.
   3.  The contents of the environment, excluding the MAKEFLAGS and SHELL
variables and including the variables with null values.
   4.  Macros defined in the inference rules built into make.

Macro definitions from these sources shall not override macro definitions from
a lower-numbered source. Macro definitions from a single source (for example,
the make utility command line, the MAKEFLAGS environment variable, or the
other environment variables) shall override previous macro definitions from
the same source.

Macros defined in the makefile(s) shall override macro definitions that occur
before them in the makefile(s) and macro definitions from source 4. If the -e
option is not specified, macros defined in the makefile(s) shall override
macro definitions from source 3. Macros defined in the makefile(s) shall not
override macro definitions from source 1 or source 2.

[end quote]

IOW, any make variable (== macro in POSIX quote above) can be explicitly
set in make(1) command line in form name=value and in that case nothing in
makefile(s) can change its value.  It's true for GNU make, it's true for
BSD make and it's been true for historical Unix make since its introduction
in v7.
