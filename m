Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3JGRty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:49:54 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:42031 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3JGRtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:49:49 -0400
Date: Mon, 7 Oct 2013 10:49:43 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Cc: linux-mtd@lists.infradead.org, Joern Engel <joern@lazybastard.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: phram: Make phram 64-bit compatible
Message-ID: <20131007174943.GB23337@ld-irv-0074.broadcom.com>
References: <524C4CF5.7060601@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524C4CF5.7060601@nsn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ LKML

On Wed, Oct 02, 2013 at 06:42:29PM +0200, Alexander Sverdlin wrote:
> mtd: phram: Make phram 64-bit compatible
> 
> phram was 32-bit limited by design. Machines are growing up, but phram
> module is still useful. Update it. The patch is bigger than minimum,
> because simple_strtoul() is obsolete.
> 
> Tested on MIPS64 and compile-tested for PPC (32 bit).
> 
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nsn.com>

Pushed to l2-mtd.git. Thanks!

Can this driver use the library memparse() function instead of
open-coding it?

[To answer myself:] I noticed this in drivers/mtd/devices/phram.c, which
prevents us from using memparse():

  /* By dwmw2 editorial decree, "ki", "Mi" or "Gi" are to be used. */

Are we (MTD) holding a revolutionary position against the standard
kernel libraries, which recognize [KkMmGg] prefixes, but not [kMG]i
prefixes? Should we extend memparse() to accept either form? Or would
doing so simply pollute the library and not really satisfy anyone?

[After more research:] It looks like this topic may be the subject of
some long-past flame wars. If I am digging up past demons, then I'd
prefer to let sleeping Balrogs lie.

Brian
