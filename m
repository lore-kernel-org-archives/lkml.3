Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaBCLvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:51:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51237 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaBCLvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:51:50 -0500
Date: Mon, 3 Feb 2014 06:50:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>, jonathan.davies@citrix.com,
        wei.liu2@citrix.com, ian.campbell@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        netdev@vger.kernel.org, Julien Grall <julien.grall@linaro.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH v6] xen/grant-table: Avoid m2p_override
 during mapping
Message-ID: <20140203115040.GB3400@phenom.dumpdata.com>
References: <1390512224-27296-1-git-send-email-zoltan.kiss@citrix.com>
 <alpine.DEB.2.02.1401232333280.15917@kaball.uk.xensource.com>
 <52EE1E26.2040308@linaro.org>
 <52EE93F0.1020508@citrix.com>
 <52EF7618.7030402@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52EF7618.7030402@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 10:57:28AM +0000, David Vrabel wrote:
> On 02/02/14 18:52, Zoltan Kiss wrote:
> > On 02/02/14 11:29, Julien Grall wrote:
> >> Hello,
> >>
> >> This patch is breaking Linux compilation on ARM:
> >>
> >> drivers/xen/grant-table.c: In function ‘__gnttab_map_refs’:
> >> drivers/xen/grant-table.c:989:3: error: implicit declaration of
> >> function ‘FOREIGN_FRAME’ [-Werror=implicit-function-declaration]
> >>     if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)))) {
> >>     ^
> >> drivers/xen/grant-table.c: In function ‘__gnttab_unmap_refs’:
> >> drivers/xen/grant-table.c:1054:3: error: implicit declaration of
> >> function ‘get_phys_to_machine’ [-Werror=implicit-function-declaration]
> >>     mfn = get_phys_to_machine(pfn);
> >>     ^
> >> drivers/xen/grant-table.c:1055:43: error: ‘FOREIGN_FRAME_BIT’
> >> undeclared (first use in this function)
> >>     if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
> >>                                             ^
> >> drivers/xen/grant-table.c:1055:43: note: each undeclared identifier is
> >> reported only once for each function it appears in
> >> drivers/xen/grant-table.c:1068:9: error: too many arguments to
> >> function ‘m2p_remove_override’
> >>           mfn);
> >>           ^
> >> In file included from include/xen/page.h:4:0,
> >>                   from drivers/xen/grant-table.c:48:
> >> /local/home/julien/works/midway/linux/arch/arm/include/asm/xen/page.h:106:19:
> >> note: declared here
> >>   static inline int m2p_remove_override(struct page *page, bool
> >> clear_pte)
> >>                     ^
> >> cc1: some warnings being treated as errors
> > 
> > Hi,
> > 
> > That's bad indeed. I think the best solution is to put those parts
> > behind an #ifdef x86. The ones moved from x86/p2m.c to grant-table.c.
> > David, Stefano, what do you think?
> 
> I don't think we want (more) #ifdef CONFIG_X86 in grant-table.c and the
> arch-specific bits will have to factored out into their own functions
> with suitable stubs provided for ARM.
> 
> But, this patch went in late and it's clearly not ready. So I think it
> should be reverted and we should aim to get it sorted out for 3.15.
> 
> Konrad/Stefano (if you agree) please revert
> 08ece5bb2312b4510b161a6ef6682f37f4eac8a1 and send a pull request.

OK, queued up. I also put on the xen/cr4 patch on the queue - just sent
an email with it.

> 
> Konrad, I also think you should look at adding an ARM build to your test
> system (I thought you had this already).
> 
> David
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
