Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3KXW4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 17:56:01 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42221 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751635Ab3KXW4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 17:56:00 -0500
Date: Sun, 24 Nov 2013 19:56:10 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>, grinberg@compulab.co.il
Subject: Re: [PATCH] ARM: pxa: Move iotable mapping inside vmalloc region
Message-ID: <20131124225610.GB2448@localhost>
References: <1385296571-23599-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <20131124124125.GM16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131124124125.GM16735@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 12:41:25PM +0000, Russell King - ARM Linux wrote:
> On Sun, Nov 24, 2013 at 09:36:11AM -0300, Ezequiel Garcia wrote:
> > In order to remove the following ugly message:
> > 
> >   BUG: mapping for 0x00000000 at 0xff000000 out of vmalloc space
> > 
> > the iotable mappings should be re-located inside the vmalloc
> > region. Such move was introduced at commit:
> > 
> > commit 0536bdf33faff4d940ac094c77998cfac368cfff
> > Author: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Date:   Thu Aug 25 00:35:59 2011 -0400
> > 
> >     ARM: move iotable mappings within the vmalloc region
> > 
> > While at it, let's add some nicer defines to make the code
> > more readable.
> > 
> > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> 
> NAK.  I'm guessing that you haven't properly tested this.  Grep for
> UNCACHED_PHYS_0, and what you'll find is that your change will break
> standby and suspend on all PXA platforms.

Right, I fail to grep about this properly, sorry about that.
Anyway, after grepping for 'UNCACHED' and doing some testings
I found a few interesting things.

First, UNCACHED_PHYS_0 seems to be used by PXA27xx and PXA25xx. The
board I have here is PXA3xx, so there's no way I can test anything.

Question: Should we add an #ifdef around the mapping, or is that
just pure churn?

Second, suspend/resume seems broken on my CM-X300 board, or at least
the wake-up. It enters suspend/standby but then never seem to wake.
Maybe I'm not pushing the right button, but according to the reference
guide the SW2 (connected to EXTWAKE#) should do the trick.

Ideas?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
