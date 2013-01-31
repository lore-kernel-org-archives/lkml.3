Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3AaJta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:49:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59008 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab3AaJt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:49:28 -0500
Date: Thu, 31 Jan 2013 10:49:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, numa: Use __pa_nodebug instead
Message-ID: <20130131094923.GE4926@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
References: <1359245901-8512-1-git-send-email-bp@alien8.de>
 <5106CE88.2030005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5106CE88.2030005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 11:16:24AM -0800, Dave Hansen wrote:
> On 01/26/2013 04:18 PM, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > ... and fix the following warning:
> > 
> > arch/x86/mm/numa.c: In function ‘setup_node_data’:
> > arch/x86/mm/numa.c:222:3: warning: passing argument 1 of ‘__phys_addr_nodebug’ makes integer from pointer without a cast [enabled by default]
> > In file included from /home/boris/w/kernel/linux-2.6/arch/x86/include/asm/page.h:11:0,
> >                  from /home/boris/w/kernel/linux-2.6/arch/x86/include/asm/thread_info.h:11,
> >                  from include/linux/thread_info.h:54,
> >                  from include/linux/preempt.h:9,
> >                  from include/linux/spinlock.h:50,
> >                  from include/linux/mmzone.h:7,
> >                  from include/linux/gfp.h:4,
> >                  from include/linux/mm.h:8,
> >                  from arch/x86/mm/numa.c:3:
> > /home/boris/w/kernel/linux-2.6/arch/x86/include/asm/page_64.h:12:29: note: expected ‘long unsigned int’ but argument is of type ‘void *’
> > 
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> 
> I was just about to send out a patch for it and came up with the same fix.
> 
> Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

This still triggers on tip:x86/mm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
