Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaCRGxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 02:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaCRGxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 02:53:18 -0400
Date: Tue, 18 Mar 2014 07:52:19 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org,
        kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: declare notifier_block on xen-ops.h
Message-ID: <20140318065218.GB1465@redhat.com>
References: <5323aab1.r24xwrkmR/N+a3KK%fengguang.wu@intel.com>
 <20140317074850.GB1767@redhat.com>
 <53273733.6080506@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53273733.6080506@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 05:56:03PM +0000, David Vrabel wrote:
> On 17/03/14 07:48, Stanislaw Gruszka wrote:
> > Patch fixes below warnings:
> > 
> >    In file included from arch/x86/xen/xen-ops.h:7:0,
> >                     from arch/x86/xen/vga.c:9:
> >>> include/xen/xen-ops.h:19:42: warning: 'struct notifier_block' declared inside parameter list [enabled by default]
> >     void xen_resume_notifier_register(struct notifier_block *nb);
> >                                              ^
> >>> include/xen/xen-ops.h:19:42: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> >>> include/xen/xen-ops.h:20:44: warning: 'struct notifier_block' declared inside parameter list [enabled by default]
> >     void xen_resume_notifier_unregister(struct notifier_block *nb);
> 
> Is this a fix up to your previous  "xen/acpi-processor: fix enabling
> interrupts on syscore_resume" patch? 
Yes.

> If so, do you mind if we squash
> the two commits together?  So bisectability is improved.
No problem with that (though I don't think actual build is broken
since we don't use xen_resume_notifier_register on .c files that
do not include linux/notifier.h directly or indirectly).
 
Thanks
Stanislaw
