Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaIZR0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:26:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4779 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbaIZR0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:26:41 -0400
X-IronPort-AV: E=Sophos;i="5.04,604,1406592000"; 
   d="scan'208";a="176588412"
Message-ID: <5425A1CE.7090704@citrix.com>
Date: Fri, 26 Sep 2014 18:26:38 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V5 PATCH 1/1] x86/xen: Set EFER.NX and EFER.SCE
 in PVH guests
References: <1410392166-16388-1-git-send-email-mukesh.rathor@oracle.com> <1410392166-16388-2-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1410392166-16388-2-git-send-email-mukesh.rathor@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/14 00:36, Mukesh Rathor wrote:
> This fixes two bugs in PVH guests:
> 
>   - Not setting EFER.NX means the NX bit in page table entries is
>     ignored on Intel processors and causes reserved bit page faults on
>     AMD processors.
> 
>   - After the Xen commit 7645640d6ff1 ("x86/PVH: don't set EFER_SCE for
>     pvh guest") PVH guests are required to set EFER.SCE to enable the
>     SYSCALL instruction.
> 
> Secondary VCPUs are started with pagetables with the NX bit set so
> EFER.NX must be set before using any stack or data segment.
> xen_pvh_cpu_early_init() is the new secondary VCPU entry point that
> sets EFER before jumping to cpu_bringup_and_idle().

Applied to devel/for-linus-3.18

Thanks.

David
