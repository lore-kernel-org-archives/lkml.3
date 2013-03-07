Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911Ab3CGWFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:05:25 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56747 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3CGWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:05:24 -0500
X-Nat-Received: from [202.181.97.72]:63222 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1362693922.1809
To: dave@sr71.net, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, hpa@linux.intel.com, x86@kernel.org,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        khlebnikov@openvz.org, bhelgaas@google.com
Subject: Re: [PATCH] do not try to sync identity map for non-mapped pages
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com>
In-Reply-To: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com>
Message-Id: <201303080705.CFJ06290.FHMFVtOSJFLOQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 8 Mar 2013 07:05:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 07032013 #9677513, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> 
> The original bug reporter says this fixes it for him, so I'm
> broadening the cc list a bit.  I assume this should just get
> sucked in to the x86 tree.
> 
> The double-signed-off-by from my is because my IBM email is
> going away very shortly.
> 
> --
> 
> kernel_map_sync_memtype() is called from a variety of contexts.  The
> pat.c code that calls it seems to ensure that it is not called for
> non-ram areas by checking via pat_pagerange_is_ram().  It is important
> that it only be called on the actual identity map because there *IS*
> no map to sync for highmem pages, or for memory holes.
> 
> The ioremap.c uses are not as careful as those from pat.c, and call
> kernel_map_sync_memtype() on PCI space which is in the middle of the
> kernel identity map _range_, but is not actually mapped.
> 
> This patch adds a check to kernel_map_sync_memtype() which probably
> duplicates some of the checks already in pat.c.  But, it is necessary
> for the ioremap.c uses and shouldn't hurt other callers.
> 
> I have reproduced this bug and this patch fixes it for me and the
> original bug reporter:
> 
> 	https://lkml.org/lkml/2013/2/5/396
> 

Excuse me, but I didn't realize that the link is wrong.

https://lkml.org/lkml/2013/2/5/396 is a bug in CONFIG_MICROCODE_INTEL_EARLY=y
&& CONFIG_64BIT=n && CONFIG_DEBUG_VIRTUAL=y where patches are not available.

https://lkml.org/lkml/2013/3/5/314 is a bug in CONFIG_ACPI=y &&
CONFIG_DEBUG_VIRTUAL=y where your patch fixes.

Please use https://lkml.org/lkml/2013/3/5/314 rather than
https://lkml.org/lkml/2013/2/5/396 in your patch.

Regards.
