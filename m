Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaIKJbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaIKJbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:31:42 -0400
Date: Thu, 11 Sep 2014 17:31:30 +0800
From: Baoquan He <bhe@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>, Dave Young <dyoung@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle
 relocations
Message-ID: <20140911093130.GC4411@dhcp-16-116.nay.redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-2-git-send-email-bhe@redhat.com>
 <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
 <20140909062416.GA2872@dhcp-16-105.nay.redhat.com>
 <CAGXu5jJ+oUGszKUX12cqJ9RQBXCzO9j9e-5gBDmTH-cF80=xNg@mail.gmail.com>
 <20140909192813.GB9435@redhat.com>
 <20140910072115.GA31685@dhcp-16-116.nay.redhat.com>
 <20140910143019.GA3771@redhat.com>
 <CAGXu5jLTd=xvhjiSGsp5FiT7w0cSctZF2KPOvfU=1_R8Up-97w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLTd=xvhjiSGsp5FiT7w0cSctZF2KPOvfU=1_R8Up-97w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 at 07:41am, Kees Cook wrote:
> On Wed, Sep 10, 2014 at 7:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > So I would suggest that test and repost the other patch with proper changelog
> > and that might be sufficient for now. Only other thing we will need is
> > Kees's patch for avoiding setup data regions in kaslr.
> 
> If someone can confirm that my patch works, I can request x86 pull it.
> 
> Currently living here:
> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kaslr

Hi Kees,

I tested your patch, it works. The way is like below:

I changed kexec-tools to make all add_buffer doing from down to top.
Then all stuff including kernel, initrd, setupda, cmdline, realmode_data
all are put inside 0~1G. And set E820_MAX to 10, since on my pc there are 17
memoery regions, then 7 memory regions are added into setup_data as a
blob. Then copy arch/x86/boot/printf.c to arch/x86/boot/compressed/ and
make it work. From printing message, the setup data is checking each
time when a memory slot is added.

> 
> Thanks!
> 
> -Kees
> 
> -- 
> Kees Cook
> Chrome OS Security
