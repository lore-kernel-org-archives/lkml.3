Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaKLScY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:32:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45065 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaKLScW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:32:22 -0500
Date: Wed, 12 Nov 2014 13:32:10 -0500 (EST)
Message-Id: <20141112.133210.2150102649123612493.davem@davemloft.net>
To: khalid.aziz@oracle.com
Cc: bob.picco@oracle.com, sam@ravnborg.org, mgorman@suse.de, riel@redhat.com,
        tkhai@yandex.ru, allen.pais@oracle.com, sfr@canb.auug.org.au,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: Resolve conflict between sparc v9 and M7 on
 usage of bit 9 of TTE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415810741-25131-1-git-send-email-khalid.aziz@oracle.com>
References: <1415810741-25131-1-git-send-email-khalid.aziz@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 10:32:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Khalid Aziz <khalid.aziz@oracle.com>
Date: Wed, 12 Nov 2014 09:45:41 -0700

> sparc64: Resolve conflict between sparc v9 and M7 on usage of bit 9 of TTE
> 
> Bit 9 of TTE is CV (Cacheable in V-cache) on sparc v9 processor while
> the same bit 9 is MCDE (Memory Corruption Detection Enable) on M7
> processor. This creates a conflicting usage of the same bit. Kernel
> sets TTE.cv bit on all pages for sun4v architecture which works well
> for sparc v9, but sets memory corruption detection bit on M7 processor
> which is not the intent. This patch adds code to determine if kernel
> is running on M7 processor and takes steps to not enable memory
> corruption detection in TTE erroneously.
> 
> Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>

The hypervisor specification clearly defines bit 9 as V-Cache
cacheable.

Reusing this bit instead of doing something else was quite unwise if
you ask me.

I also really want a programmers manual for the M7 chip at this point
before I'm willing to apply any patches of this nature.

It's nearly impossible for me to sufficiently review all of the recent
binutils (for new instructions) and now kernel (redefined TTE bits)
changes without access to the programmer's manual.

Thanks.
