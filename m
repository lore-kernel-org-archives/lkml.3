Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3FKJTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3FKJTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:19:14 -0400
Date: Tue, 11 Jun 2013 12:18:48 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/6] KVM: MMU: make return value of mmio page fault
 handler more readable
Message-ID: <20130611091848.GJ4725@redhat.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1370595088-3315-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130610075750.GZ4725@redhat.com>
 <20130610221604.87fa64de18c9cb56eed0e013@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610221604.87fa64de18c9cb56eed0e013@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 10:16:04PM +0900, Takuya Yoshikawa wrote:
> On Mon, 10 Jun 2013 10:57:50 +0300
> Gleb Natapov <gleb@redhat.com> wrote:
> 
> > On Fri, Jun 07, 2013 at 04:51:25PM +0800, Xiao Guangrong wrote:
> 
> > > +
> > > +/*
> > > + * Return values of handle_mmio_page_fault_common:
> > > + * RET_MMIO_PF_EMULATE: it is a real mmio page fault, emulate the instruction
> > > + *			 directly.
> > > + * RET_MMIO_PF_RETRY: let CPU fault again on the address.
> > > + * RET_MMIO_PF_BUG: bug is detected.
> > > + */
> > > +enum {
> > > +	RET_MMIO_PF_EMULATE = 1,
> > > +	RET_MMIO_PF_RETRY = 0,
> > > +	RET_MMIO_PF_BUG = -1
> > > +};
> > I would order them from -1 to 1 and rename RET_MMIO_PF_BUG to
> > RET_MMIO_PF_ERROR, but no need to resend just for that.
> 
> Why not just let compilers select the values? -- It's an enum.
> Any reason to make it start from -1?
> 
I am fine with this too as an additional patch. It makes sense to preserve
original values like Xiao did for initial patch, since it is easier to
verify that the patch is just a mechanical change.

--
			Gleb.
