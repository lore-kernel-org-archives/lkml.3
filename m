Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaH1OSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:18:30 -0400
Received: from smtp.citrix.com ([66.165.176.89]:47135 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbaH1OS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:18:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,418,1406592000"; 
   d="scan'208";a="166021967"
Message-ID: <53FF3A32.7000805@citrix.com>
Date: Thu, 28 Aug 2014 15:18:26 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V1 PATCH 1/2] PVH: set EFER.NX and EFER.SCE for
 boot vcpu
References: <1409178815-2026-1-git-send-email-mukesh.rathor@oracle.com> <1409178815-2026-2-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1409178815-2026-2-git-send-email-mukesh.rathor@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/14 23:33, Mukesh Rathor wrote:
> This patch addresses three things for a pvh boot vcpu:
> 
>   - NX bug on intel: It was recenlty discovered that NX is not being
>     honored in PVH on intel since EFER.NX is not being set. The pte.NX
>     bits are ignored if EFER.NX is not set on intel.

I am unconvinced by this explanation.  The Intel SDM clearly states that
the XD bit in the page table entries is reserved if EFER.NXE is clear,
and thus using a entry with XD set and EFER.NXE clear should generate a
page fault (same as AMD).

You either need to find out why Intel really worked (perhaps Xen is
setting EFER.NXE on Intel?) or you need to included an errata (or
similar) reference.

>   - PVH boot hang on newer xen:  Following c/s on xen
> 
>         c/s 7645640:  x86/PVH: don't set EFER_SCE for pvh guest

As I already explained in another email, the Xen change caused a
regression and must be reverted.

David
