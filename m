Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaKSUlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:41:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17462 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaKSUlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:41:53 -0500
Date: Wed, 19 Nov 2014 15:41:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 0/8] xen: Switch to virtual mapped linear p2m list
Message-ID: <20141119204131.GD18495@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415684626-18590-1-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 06:43:38AM +0100, Juergen Gross wrote:
> Paravirtualized kernels running on Xen use a three level tree for
> translation of guest specific physical addresses to machine global
> addresses. This p2m tree is used for construction of page table
> entries, so the p2m tree walk is performance critical.
> 
> By using a linear virtual mapped p2m list accesses to p2m elements
> can be sped up while even simplifying code. To achieve this goal
> some p2m related initializations have to be performed later in the
> boot process, as the final p2m list can be set up only after basic
> memory management functions are available.
> 

Hey Juergen,

I finially finished looking at the patchset. Had some comments,
some questions that I hope can make it in the patch so that in
six months or so when somebody looks at the code they can
understand the subtle pieces.

Looking forward to the v4! (Thought keep in mind that next week
is Thanksgiving week so won't be able to look much after Wednesday)

>  arch/x86/include/asm/pgtable_types.h |    1 +
>  arch/x86/include/asm/xen/page.h      |   49 +-
>  arch/x86/mm/pageattr.c               |   20 +
>  arch/x86/xen/mmu.c                   |   38 +-
>  arch/x86/xen/p2m.c                   | 1315 ++++++++++++++--------------------
>  arch/x86/xen/setup.c                 |  460 ++++++------
>  arch/x86/xen/xen-ops.h               |    6 +-
>  7 files changed, 854 insertions(+), 1035 deletions(-)

And best of - we are deleting more code!

> 
> -- 
> 2.1.2
> 
