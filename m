Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab3CHH2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:28:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42113 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3CHH2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:28:51 -0500
Date: Thu, 7 Mar 2013 23:28:46 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 04/14] x86, ACPI: make acpi override finding work with
 32bit flat mode
Message-ID: <20130308072846.GQ14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-5-git-send-email-yinghai@kernel.org>
 <20130308055023.GF14556@mtj.dyndns.org>
 <CAE9FiQVXOC71BGSK3t_xg+nP5Qq8ZKoup0sTMJDPnv-y8++=hg@mail.gmail.com>
 <20130308070651.GN14556@mtj.dyndns.org>
 <CAE9FiQXWzYVeCJOGffsvp3-wUHEMP21f3EA8Qcswn-B4fXC5uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXWzYVeCJOGffsvp3-wUHEMP21f3EA8Qcswn-B4fXC5uQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 11:25:14PM -0800, Yinghai Lu wrote:
> >> > Why is this table made a stack variable?  What's the benefit of doing
> >> > that?
> >>
> >> so I do need to switch global variables to phys and access it.
> >
> > I can't really understand what your response means.  Can you please
> > elaborate?
> 
> sorry, I missed NOT.
> 
> so I do NOT need to switch global variables from kernel virtual addr
> to phys address and access it
> in 32bit flat mode.

Ah, okay, so the function is called with a completely different
address mode and so you actually want to build the table on stack so
that you don't have to flip the address mode for the global address.

> >> yes, one for 32bit from head_32.S, phys.
> >> one for 64bit from head64.c. with _va.
> >
> > head64.c can't call with phys?  Why not?
> 
> HPA's #PF set up page table only handle kernel low mapping address.
> 
> and after reset_early_page_tables, only kernel high mapping address is
> there. and other low mapping will be supported via #PF handler.

Okay, it now makes sense.  Ah.... You'll definitely need a lot of
documentation explanining what's going on.

Thanks.

-- 
tejun
