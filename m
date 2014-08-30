Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074AbaH3WyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 18:54:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59490 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaH3WyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 18:54:21 -0400
Date: Sat, 30 Aug 2014 23:54:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v3 1/5] seq_file: provide an analogue of print_hex_dump()
Message-ID: <20140830225407.GF7996@ZenIV.linux.org.uk>
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408957395-404-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408957395-404-2-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 12:03:11PM +0300, Andy Shevchenko wrote:
> The new seq_hex_dump() is a complete analogue of print_hex_dump().
> 
> We have few users of this functionality already. It allows to reduce their
> codebase.

I really don't like the stack footprint.

> +	unsigned char linebuf[32 * 3 + 2 + 32 + 1];

... and extra copying for no good reason.  Why not check that we have
enough space in buffer and generate directly into it?  See what e.g.
seq_escape() is doing...
