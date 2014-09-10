Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaIJN4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaIJN4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:56:17 -0400
Date: Wed, 10 Sep 2014 21:55:55 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>, Dave Young <dyoung@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/4] kaslr: check if the random addr is available
Message-ID: <20140910135555.GA1887@dhcp-17-102.nay.redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-3-git-send-email-bhe@redhat.com>
 <CAGXu5jJXvR9c3OvkX-gBMjhJEwXh5-wBdT+jjMwBFXDs8_-40Q@mail.gmail.com>
 <20140905221657.GA1675@dhcp-17-102.nay.redhat.com>
 <20140909194118.GA20681@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909194118.GA20681@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 at 03:41pm, Vivek Goyal wrote:
> On Sat, Sep 06, 2014 at 06:16:57AM +0800, Baoquan He wrote:
> 
> [CC hpa ]
> 
> > Hi Kees,
> > 
> > Yes, process_e820_entry() can make sure the choice+output_len <
> > CONFIG_RANDOMIZE_BASE_MAX_OFFSET, but that can't stop other bootloaders
> > to put kernel in region above CONFIG_RANDOMIZE_BASE_MAX_OFFSET.
> > 
> > E.g in kdump, we can set crashkernel=256M@1024M in cmdline. Then the 1st
> > kernel will reserve 256M memory just at 1024M place. So if load kdump
> > kernel now, the output will be 1024M before choose_kernel_location().
> > With this value, output won't be changed in choose_kernel_location(),
> > then it will do decompress(), then call handle_relocations(). Then since
> > 1024 is not equal to LOAD_PHYSICAL_ADDR, it will start relocatoins
> > handling. And this cause _text stamping into MODULES vaddr range. System
> > will be exceptional.
> 
> Bao,
> 
> If you apply your first patch where output_orig == output, then
> handle_relocations() will not do anything for x86_64 case and bail
> out. That should take care of this issue. Isn't it? And we should
> not require this patch.

Yes, exactly.

> 
> Thanks
> Vivek
