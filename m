Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaJNQ7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:59:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:11578 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbaJNQ7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:59:32 -0400
X-IronPort-AV: E=Sophos;i="5.04,718,1406592000"; 
   d="scan'208";a="182415306"
Message-ID: <543D565E.7020402@citrix.com>
Date: Tue, 14 Oct 2014 17:59:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen: delay construction of mfn_list_list
References: <1413286426-1415-1-git-send-email-jgross@suse.com>
In-Reply-To: <1413286426-1415-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/14 12:33, Juergen Gross wrote:
> The 3 level p2m tree for the Xen tools is constructed very early at
> boot by calling xen_build_mfn_list_list(). Memory needed for this tree
> is allocated via extend_brk().
> 
> As this tree (other than the kernel internal p2m tree) is only needed
> for domain save/restore, live migration and crash dump analysis it
> doesn't matter whether it is constructed very early or just some
> milliseconds later when memory allocation is possible by other means.
> 
> This patch moves the call of xen_build_mfn_list_list() just after
> calling xen_pagetable_p2m_copy() simplifying this function, too, as it
> doesn't have to bother with two parallel trees now. The same applies
> for some other internal functions.
> 
> While simplifying code, make early_can_reuse_p2m_middle() static and
> drop the unused second parameter. p2m_mid_identity_mfn can be removed
> as well, it isn't used either.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/xen/enlighten.c |  3 ---
>  arch/x86/xen/mmu.c       |  5 +++-
>  arch/x86/xen/p2m.c       | 65 +++++++++++-------------------------------------
>  3 files changed, 18 insertions(+), 55 deletions(-)

Nice!

Applied to stable/for-linus-3.18

Thanks.

David

