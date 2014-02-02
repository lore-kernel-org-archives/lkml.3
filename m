Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaBBSyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 13:54:44 -0500
Received: from smtp.citrix.com ([66.165.176.89]:35867 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaBBSyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 13:54:43 -0500
X-IronPort-AV: E=Sophos;i="4.95,767,1384300800"; 
   d="scan'208";a="99040643"
Message-ID: <52EE93F0.1020508@citrix.com>
Date: Sun, 2 Feb 2014 19:52:32 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <jonathan.davies@citrix.com>, <wei.liu2@citrix.com>,
        <ian.campbell@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH v6] xen/grant-table: Avoid m2p_override during
 mapping
References: <1390512224-27296-1-git-send-email-zoltan.kiss@citrix.com> <alpine.DEB.2.02.1401232333280.15917@kaball.uk.xensource.com> <52EE1E26.2040308@linaro.org>
In-Reply-To: <52EE1E26.2040308@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.68.14.36]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/14 11:29, Julien Grall wrote:
> Hello,
>
> This patch is breaking Linux compilation on ARM:
>
> drivers/xen/grant-table.c: In function ‘__gnttab_map_refs’:
> drivers/xen/grant-table.c:989:3: error: implicit declaration of function ‘FOREIGN_FRAME’ [-Werror=implicit-function-declaration]
>     if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)))) {
>     ^
> drivers/xen/grant-table.c: In function ‘__gnttab_unmap_refs’:
> drivers/xen/grant-table.c:1054:3: error: implicit declaration of function ‘get_phys_to_machine’ [-Werror=implicit-function-declaration]
>     mfn = get_phys_to_machine(pfn);
>     ^
> drivers/xen/grant-table.c:1055:43: error: ‘FOREIGN_FRAME_BIT’ undeclared (first use in this function)
>     if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
>                                             ^
> drivers/xen/grant-table.c:1055:43: note: each undeclared identifier is reported only once for each function it appears in
> drivers/xen/grant-table.c:1068:9: error: too many arguments to function ‘m2p_remove_override’
>           mfn);
>           ^
> In file included from include/xen/page.h:4:0,
>                   from drivers/xen/grant-table.c:48:
> /local/home/julien/works/midway/linux/arch/arm/include/asm/xen/page.h:106:19: note: declared here
>   static inline int m2p_remove_override(struct page *page, bool clear_pte)
>                     ^
> cc1: some warnings being treated as errors

Hi,

That's bad indeed. I think the best solution is to put those parts 
behind an #ifdef x86. The ones moved from x86/p2m.c to grant-table.c. 
David, Stefano, what do you think?

Zoli
