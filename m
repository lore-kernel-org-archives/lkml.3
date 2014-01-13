Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaAMKiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:38:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51756 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaAMKiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:38:11 -0500
Date: Mon, 13 Jan 2014 11:38:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ren Qiaowei <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
Message-ID: <20140113103808.GC5388@pd.tnic>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
 <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>
 <20140112092019.GA3664@pd.tnic>
 <52D35ABB.8070904@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D35ABB.8070904@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:17:15AM +0800, Ren Qiaowei wrote:
> Yes, I run this with lockdep enabled.

Ok, but you still are doing memory allocation in the exception handler,
AFAICT:

do_bounds
|->do_mpx_bt_fault
   |->allocate_bt
      |->sys_mmap_pgoff
         |->vm_mmap_pgoff
            |->do_mmap_pgoff
               |->mmap_region
                  |-> kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
