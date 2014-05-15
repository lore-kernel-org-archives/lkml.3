Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaEOCWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 22:22:43 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52841 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaEOCWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 22:22:42 -0400
Date: Wed, 14 May 2014 19:22:38 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: roundup_pow_of_two() may not handle 64-bit integers
Message-ID: <20140515022238.GL28907@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking to use roundup_pow_of_two() (actually, order_base_2())
from <linux/log2.h>, but it seems that it only supports 64-bit integers
if your toolchain uses a 64-bit 'unsigned long' type. This is strange,
considering that ilog2() is explicitly designed for 32-bit or 64-bit
compatibility.

I also note that there is at least one location in which this limitation
currently might be problematic: in pnv_pci_ioda2_set_bypass()
(arch/powerpc/platforms/powernv/pci-ioda.c). It looks like this could be
a problem if using large amounts of DRAM on a 32-bit PPC build, with
64-bit physical addresses.

(There may be other cases like this one, but I haven't closely studied
all callers of roundup_pow_of_two().)

I'm thinking of cooking a patch to improve roundup_pow_of_two() (and
thus order_base_2()), but I'd like to solicit comments on the basic
problem first.

Regards,
Brian

P.S. And of course, rounddown_pow_of_two() has the same issue.
