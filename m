Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbaKUECp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 23:02:45 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49409 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbaKUECo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 23:02:44 -0500
X-Originating-IP: 50.43.41.112
Date: Thu, 20 Nov 2014 20:02:34 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: leizhen <thunder.leizhen@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>
Subject: Re: Fwd: [PATCH 1/1] init:add boot option "initramfs_packnum"
Message-ID: <20141121040233.GB4993@thin>
References: <1415670134-8016-1-git-send-email-thunder.leizhen@huawei.com>
 <546EB5A2.5050604@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546EB5A2.5050604@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:46:42AM +0800, leizhen wrote:
> During the development phase, we usually enlarge initrd-end to reserve more
> memory than the initfs zip exactly occupied. Then we can easily add or delete
> files in zip package, without generate fdt again and again. But unfortunately,
> if too many zeros followed initfs zip, it will take a long time to break the
> loop.
> 
> while (!message && len) {
>         ... ...
>         if (!*buf) {
> 		buf++;
>                 ... ...
>                 continue;
>         }
> 
> So, use the boot option "initramfs_packnum" to specify how many zip packages
> in each initrd area. When the specified number of packages decompressed in one
> area, immediately terminate the loop. Have no impact on current use by default.

This seems like the wrong approach to me.  Rather than changing Linux to
ignore excess data in the initramfs, could you change your bootloader to
pass the true length of the initramfs to Linux?  Even if you reserve
extra space, if you know how much data you've actually included, you
could have your bootloader pass that information to Linux.

- Josh Triplett
