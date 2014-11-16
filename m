Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaKPNIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 08:08:54 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54530 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaKPNIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 08:08:53 -0500
Date: Sun, 16 Nov 2014 14:08:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH V6 00/18] x86: Full support of PAT
Message-ID: <20141116130847.GA4736@gmail.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Juergen Gross <jgross@suse.com> wrote:

>  arch/x86/include/asm/cacheflush.h         |  38 ++++---

FYI, this series breaks the UML build:

In file included from /home/mingo/tip/include/linux/highmem.h:11:0,
                 from /home/mingo/tip/include/linux/pagemap.h:10,
                 from /home/mingo/tip/include/linux/mempolicy.h:14,
                 from /home/mingo/tip/include/linux/shmem_fs.h:6,
                 from /home/mingo/tip/init/do_mounts.c:30:
/home/mingo/tip/arch/x86/include/asm/cacheflush.h:67:36: error: return type is an incomplete type
 static inline enum page_cache_mode get_page_memtype(struct page *pg)
                                    ^
/home/mingo/tip/arch/x86/include/asm/cacheflush.h: In function ‘get_page_memtype’:
/home/mingo/tip/arch/x86/include/asm/cacheflush.h:69:2: warning: ‘return’ with a value, in function returning void [enabled by default]
  return -1;
  ^
/home/mingo/tip/arch/x86/include/asm/cacheflush.h: At top level:
/home/mingo/tip/arch/x86/include/asm/cacheflush.h:72:30: error: parameter 2 (‘memtype’) has incomplete type
         enum page_cache_mode memtype)
                              ^
/home/mingo/tip/arch/x86/include/asm/cacheflush.h:71:20: error: function declaration isn’t a prototype [-Werror=strict-prototypes]

Thanks,

	Ingo
