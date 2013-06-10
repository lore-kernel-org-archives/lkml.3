Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3FJNQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:16:13 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42450 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3FJNQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:16:11 -0400
Date: Mon, 10 Jun 2013 22:16:04 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/6] KVM: MMU: make return value of mmio page fault
 handler more readable
Message-Id: <20130610221604.87fa64de18c9cb56eed0e013@gmail.com>
In-Reply-To: <20130610075750.GZ4725@redhat.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<1370595088-3315-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<20130610075750.GZ4725@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013 10:57:50 +0300
Gleb Natapov <gleb@redhat.com> wrote:

> On Fri, Jun 07, 2013 at 04:51:25PM +0800, Xiao Guangrong wrote:

> > +
> > +/*
> > + * Return values of handle_mmio_page_fault_common:
> > + * RET_MMIO_PF_EMULATE: it is a real mmio page fault, emulate the instruction
> > + *			 directly.
> > + * RET_MMIO_PF_RETRY: let CPU fault again on the address.
> > + * RET_MMIO_PF_BUG: bug is detected.
> > + */
> > +enum {
> > +	RET_MMIO_PF_EMULATE = 1,
> > +	RET_MMIO_PF_RETRY = 0,
> > +	RET_MMIO_PF_BUG = -1
> > +};
> I would order them from -1 to 1 and rename RET_MMIO_PF_BUG to
> RET_MMIO_PF_ERROR, but no need to resend just for that.

Why not just let compilers select the values? -- It's an enum.
Any reason to make it start from -1?

	Takuya
