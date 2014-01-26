Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaAZPO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 10:14:27 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:41221 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaAZPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 10:14:26 -0500
Date: Sun, 26 Jan 2014 16:14:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT,
 PR_MPX_RELEASE
Message-ID: <20140126151422.GA5386@gmail.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
 <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com>
 <20140126090808.GA30987@gmail.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE014F22A8@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE014F22A8@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ren, Qiaowei <qiaowei.ren@intel.com> wrote:

> The size of one bound table is 4M bytes for 64bit, and 16K bytes for 
> 32bit. It can not be accessed by user-space, and it will be accessed 
> automatically by hardware.

So, here's the bound-table allocation AFAICS:

+static bool allocate_bt(unsigned long bd_entry)
+{
+       unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
+       unsigned long bt_addr, old_val = 0;
+
+       bt_addr = sys_mmap_pgoff(0, bt_size, PROT_READ | PROT_WRITE,
+                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);

What ensures that user-space cannot access (and in particular, modify) 
the pages at bt_addr? It's a read-write anonymous mapping AFAICS.

Thanks,

	Ingo
