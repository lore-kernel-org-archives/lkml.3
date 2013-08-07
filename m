Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab3HGEiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 00:38:10 -0400
Received: from one.firstfloor.org ([193.170.194.197]:51868 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab3HGEiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 00:38:09 -0400
Date: Wed, 7 Aug 2013 06:38:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, wim@iguana.be
Subject: Re: [PATCH] lto, watchdog/hpwdt.c: Make assembler label global
Message-ID: <20130807043807.GV19750@two.firstfloor.org>
References: <1375740999-8097-1-git-send-email-andi@firstfloor.org>
 <20130806135118.aa11129d582b8aee00accb8a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130806135118.aa11129d582b8aee00accb8a@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 01:51:18PM -0700, Andrew Morton wrote:
> On Mon,  5 Aug 2013 15:16:39 -0700 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > We cannot assume that the inline assembler code always ends up
> > in the same file as the original C file.
> 
> um, why not?  You put an asm(".text\n...") into a .c file and you
> expect that assembly code to be emitted into the .s file then assembled
> into the .o file.
> 
> Obviously something somewhere is doing something unexpected.  Much more
> detail needed, please.

Sorry this is an extract from my larger LTO patchkit. I didn't fully
adapt the description.

With LTO (yes Link Time Optimization) the compiler repartitions the
individual definitions into new files, so yes the assembler statement
and the rest of the file can end up separated.

> Also...  what's "lto"?  Link Time Optimization?  It's unclear how this
> fits into that.  Please provide that additional background info in these
> patches so that others know what's going on and so that others (such as
> me) can help people avoid making these mistakes in the future.

I catch them by fixing compiler errors in my whole tree (well not
all, only the ones that happen in my setup)

https://github.com/andikleen/linux-misc/commits/lto-3.11

There's much more there, I'm currently just trying extract
some patches and make my pile smaller.

-Andi
