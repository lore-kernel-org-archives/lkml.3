Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3JaOy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:54:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:11514 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab3JaOyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:54:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,609,1378882800"; 
   d="scan'208";a="420362363"
Date: Thu, 31 Oct 2013 22:54:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: James Hogan <james.hogan@imgtec.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH -next] Fix printk_once build errors due to
 __read_mostly
Message-ID: <20131031145452.GB2277@localhost>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
 <1383149265.9435.19.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383149265.9435.19.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, Oct 30, 2013 at 09:07:45AM -0700, Joe Perches wrote:
> On Wed, 2013-10-30 at 10:18 +0000, James Hogan wrote:
> > Commit 3e39c1ab04ba (printk: mark printk_once test variable
> > __read_mostly) added __read_mostly to the __print_once bool in the
> > printk_once() macro, but __read_mostly is defined in <linux/cache.h>
> > which isn't included from <linux/printk.h>. This results in build errors
> > like this:
> > 
> > arch/metag/mm/l2cache.c: In function 'meta_l2c_setup':
> > arch/metag/mm/l2cache.c:56: error: '__read_mostly' undeclared
> 
> Fengguang?
> 
> Do you have the metag arch cross-compiler in your auto build tests?

Nope.

> Is there a list somewhere of what arches are build tested?

It's pretty much all the ones supported by

        https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/

Here are my installed ones (the highest version will be used if there
are several versions available):

gcc-4.2.4-nolibc/avr32-linux     gcc-4.6.3-nolibc/frv-linux     gcc-4.6.3-nolibc/mips64-linux     gcc-4.6.3-nolibc/sparc-linux
gcc-4.5.1-nolibc/or32-linux      gcc-4.6.3-nolibc/hppa64-linux  gcc-4.6.3-nolibc/mips-linux       gcc-4.6.3-nolibc/x86_64-linux
gcc-4.6.2-nolibc/tilegx-linux    gcc-4.6.3-nolibc/hppa-linux    gcc-4.6.3-nolibc/powerpc64-linux  gcc-4.6.3-nolibc/xtensa-linux
gcc-4.6.3-nolibc/alpha-linux     gcc-4.6.3-nolibc/i386-linux    gcc-4.6.3-nolibc/powerpc-linux    gcc-4.8.0-nolibc/microblaze-linux
gcc-4.6.3-nolibc/am33_2.0-linux  gcc-4.6.3-nolibc/ia64-linux    gcc-4.6.3-nolibc/s390x-linux      gcc-4.8.0-nolibc/powerpc64-linux
gcc-4.6.3-nolibc/cris-linux      gcc-4.6.3-nolibc/m32r-linux    gcc-4.6.3-nolibc/sh4-linux
gcc-4.6.3-nolibc/crisv32-linux   gcc-4.6.3-nolibc/m68k-linux    gcc-4.6.3-nolibc/sparc64-linux

Thanks,
Fengguang
