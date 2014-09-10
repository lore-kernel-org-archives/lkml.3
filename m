Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaIJPOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:14:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaIJPOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:14:14 -0400
Date: Wed, 10 Sep 2014 23:13:58 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>, Dave Young <dyoung@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle
 relocations
Message-ID: <20140910151358.GC1887@dhcp-17-102.nay.redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-2-git-send-email-bhe@redhat.com>
 <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
 <20140909062416.GA2872@dhcp-16-105.nay.redhat.com>
 <CAGXu5jJ+oUGszKUX12cqJ9RQBXCzO9j9e-5gBDmTH-cF80=xNg@mail.gmail.com>
 <20140909192813.GB9435@redhat.com>
 <20140910072115.GA31685@dhcp-16-116.nay.redhat.com>
 <20140910143019.GA3771@redhat.com>
 <20140910145334.GB1887@dhcp-17-102.nay.redhat.com>
 <20140910150432.GA7898@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910150432.GA7898@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 at 11:04am, Vivek Goyal wrote:
> On Wed, Sep 10, 2014 at 10:53:34PM +0800, Baoquan He wrote:
> > On 09/10/14 at 10:30am, Vivek Goyal wrote:
> > > In case of kdump we will have to pass nokaslr, as we don't want kernel
> > > to move as it could stomp over other things we have loaded.
> > 
> > For kdump and kexec nokaslr is unnecessary. As you know we always
> > call add_buffer with buf_end as 1, this will cause kernel loaded at the
> > top of available memory. E.g on my pc with 16G memory, kexec kernel will
> > be put nearby 16G, so no random location choosing happen as I said in
> > above. For kdump, if reserved memory is at 500M~700M, then kernel will
> > be put nearby 700M, the random location choosing also never happen.
> > 
> > In fact, for some cases I need change kexec-tools user app code, to make
> > kernel be put from down to top.
> 
> I think we can't rely on where exactly in memory kexec-tools places the
> kernel. For kdump case we will have to pass nokaslr to make sure that
> kaslr does not move kernel.

In fact with this fix, it still works though kdump kernel is relocated
if kdump kernel is put in a low addr of reserved memory. But I am fine
with it that adding nokaslr to make it safer.

> 
> Thanks
> Vivek
