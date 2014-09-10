Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaIJPjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:39:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaIJPjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:39:01 -0400
Date: Wed, 10 Sep 2014 11:38:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>, Dave Young <dyoung@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle
 relocations
Message-ID: <20140910153847.GC3771@redhat.com>
References: <1409926097-2101-2-git-send-email-bhe@redhat.com>
 <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
 <20140909062416.GA2872@dhcp-16-105.nay.redhat.com>
 <CAGXu5jJ+oUGszKUX12cqJ9RQBXCzO9j9e-5gBDmTH-cF80=xNg@mail.gmail.com>
 <20140909192813.GB9435@redhat.com>
 <20140910072115.GA31685@dhcp-16-116.nay.redhat.com>
 <20140910143019.GA3771@redhat.com>
 <CAGXu5jLTd=xvhjiSGsp5FiT7w0cSctZF2KPOvfU=1_R8Up-97w@mail.gmail.com>
 <20140910150525.GB7898@redhat.com>
 <20140910152716.GD1887@dhcp-17-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910152716.GD1887@dhcp-17-102.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:27:16PM +0800, Baoquan He wrote:
> On 09/10/14 at 11:05am, Vivek Goyal wrote:
> > On Wed, Sep 10, 2014 at 07:41:38AM -0700, Kees Cook wrote:
> > > On Wed, Sep 10, 2014 at 7:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > So I would suggest that test and repost the other patch with proper changelog
> > > > and that might be sufficient for now. Only other thing we will need is
> > > > Kees's patch for avoiding setup data regions in kaslr.
> > > 
> > > If someone can confirm that my patch works, I can request x86 pull it.
> > > 
> > > Currently living here:
> > > https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kaslr
> > > 
> > 
> > Bao,
> > 
> > Can you please test Kees's patch and provide feedback.
> 
> I can only use a trick by setting the E820_MAX to a very small number,
> say 10 in kexec-tools. Then extra memory regions will be added into
> setup data. Sufficient real test can't be taken by me since lack of
> machine.

I think modifying kexec-tools test should be good. Also we prepare
an kexec specific data blob for EFI machines and pass to second
kernel through setup_data. We can put some printk and make sure
this patch avoids that region. 

Thanks
Vivek
