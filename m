Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaELXQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 19:16:10 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63603 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaELXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 19:16:08 -0400
Date: Mon, 12 May 2014 16:16:04 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: Fix warning in access_ok() parameter passing
Message-ID: <20140512231604.GT28907@ld-irv-0074>
References: <1398969654-5672-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398969654-5672-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 08:40:54PM +0200, Geert Uytterhoeven wrote:
> On m68k, where access_ok() doesn't cast the address parameter:
> 
> drivers/mtd/mtdchar.c: In function 'mtdchar_write_ioctl':
> drivers/mtd/mtdchar.c:575:4: warning: passing argument 2 of 'access_ok' makes pointer from integer without a cast [enabled by default]
> arch/m68k/include/asm/uaccess_mm.h:17:90: note: expected 'const void *' but argument is of type '__u64'
> drivers/mtd/mtdchar.c:576:4: warning: passing argument 2 of 'access_ok' makes pointer from integer without a cast [enabled by default]
> arch/m68k/include/asm/uaccess_mm.h:17:90: note: expected 'const void *' but argument is of type '__u64'
> 
> The address parameter of access_ok() is really a userspace pointer.
> On most architectures, access_ok() is a macro that casts the address
> parameter, hiding issues in its users.
> 
> Move around and use the existing usr_data and usr_oob temporary variables
> to kill the warnings. Add a few "consts", and make more use of the
> temporaries while we're at it.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Pushed to l2-mtd.git. Thanks!

Brian
