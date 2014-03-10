Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaCJRgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:36:14 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51310 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbaCJRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:36:12 -0400
X-IronPort-AV: E=Sophos;i="4.97,625,1389744000"; 
   d="scan'208";a="108418383"
Message-ID: <531DF7FE.1000708@citrix.com>
Date: Mon, 10 Mar 2014 17:35:58 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Matt Wilson <msw@linux.com>,
        Anthony Liguori <aliguori@amazon.com>,
        =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/grant-table: Refactor gnttab_[un]map_refs to avoid
 m2p_override
References: <1393516530-9145-1-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1393516530-9145-1-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/14 15:55, Zoltan Kiss wrote:
> (This is a continuation of "[PATCH v9] xen/grant-table: Avoid m2p_override
> during mapping")
> 
> The grant mapping API does m2p_override unnecessarily: only gntdev needs it,
> for blkback and future netback patches it just cause a lock contention, as
> those pages never go to userspace. Therefore this series does the following:
> - the bulk of the original function (everything after the mapping hypercall)
>   is moved to arch-dependent set/clear_foreign_p2m_mapping
> - the "if (xen_feature(XENFEAT_auto_translated_physmap))" brach goes to ARM
> - therefore the ARM function could be much smaller, the m2p_override stubs
>   could be also removed
> - on x86 the set_phys_to_machine calls were moved up to this new funcion
>   from m2p_override functions
> - and m2p_override functions are only called when there is a kmap_ops param
> 
> It also removes a stray space from arch/x86/include/asm/xen/page.h.

Applied to devel/for-linus-3.15.

Thanks.

David
