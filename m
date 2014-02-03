Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaBCK5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:57:33 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:51108 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaBCK5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:57:31 -0500
X-IronPort-AV: E=Sophos;i="4.95,771,1384300800"; 
   d="scan'208";a="97226482"
Message-ID: <52EF7618.7030402@citrix.com>
Date: Mon, 3 Feb 2014 10:57:28 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <jonathan.davies@citrix.com>, <wei.liu2@citrix.com>,
        <ian.campbell@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v6] xen/grant-table: Avoid m2p_override during
 mapping
References: <1390512224-27296-1-git-send-email-zoltan.kiss@citrix.com>	<alpine.DEB.2.02.1401232333280.15917@kaball.uk.xensource.com>	<52EE1E26.2040308@linaro.org> <52EE93F0.1020508@citrix.com>
In-Reply-To: <52EE93F0.1020508@citrix.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/14 18:52, Zoltan Kiss wrote:
> On 02/02/14 11:29, Julien Grall wrote:
>> Hello,
>>
>> This patch is breaking Linux compilation on ARM:
>>
>> drivers/xen/grant-table.c: In function ‘__gnttab_map_refs’:
>> drivers/xen/grant-table.c:989:3: error: implicit declaration of
>> function ‘FOREIGN_FRAME’ [-Werror=implicit-function-declaration]
>>     if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)))) {
>>     ^
>> drivers/xen/grant-table.c: In function ‘__gnttab_unmap_refs’:
>> drivers/xen/grant-table.c:1054:3: error: implicit declaration of
>> function ‘get_phys_to_machine’ [-Werror=implicit-function-declaration]
>>     mfn = get_phys_to_machine(pfn);
>>     ^
>> drivers/xen/grant-table.c:1055:43: error: ‘FOREIGN_FRAME_BIT’
>> undeclared (first use in this function)
>>     if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
>>                                             ^
>> drivers/xen/grant-table.c:1055:43: note: each undeclared identifier is
>> reported only once for each function it appears in
>> drivers/xen/grant-table.c:1068:9: error: too many arguments to
>> function ‘m2p_remove_override’
>>           mfn);
>>           ^
>> In file included from include/xen/page.h:4:0,
>>                   from drivers/xen/grant-table.c:48:
>> /local/home/julien/works/midway/linux/arch/arm/include/asm/xen/page.h:106:19:
>> note: declared here
>>   static inline int m2p_remove_override(struct page *page, bool
>> clear_pte)
>>                     ^
>> cc1: some warnings being treated as errors
> 
> Hi,
> 
> That's bad indeed. I think the best solution is to put those parts
> behind an #ifdef x86. The ones moved from x86/p2m.c to grant-table.c.
> David, Stefano, what do you think?

I don't think we want (more) #ifdef CONFIG_X86 in grant-table.c and the
arch-specific bits will have to factored out into their own functions
with suitable stubs provided for ARM.

But, this patch went in late and it's clearly not ready. So I think it
should be reverted and we should aim to get it sorted out for 3.15.

Konrad/Stefano (if you agree) please revert
08ece5bb2312b4510b161a6ef6682f37f4eac8a1 and send a pull request.

Konrad, I also think you should look at adding an ARM build to your test
system (I thought you had this already).

David
