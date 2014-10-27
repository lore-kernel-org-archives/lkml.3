Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaJ0PQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:16:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:64186 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaJ0PQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:16:51 -0400
X-IronPort-AV: E=Sophos;i="5.04,796,1406592000"; 
   d="scan'208";a="186510100"
Message-ID: <544E61DD.8050305@citrix.com>
Date: Mon, 27 Oct 2014 15:16:45 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 0/2] xen: Switch to virtual mapped linear p2m list
References: <1414421551-31555-1-git-send-email-jgross@suse.com>
In-Reply-To: <1414421551-31555-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/14 14:52, Juergen Gross wrote:
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

What impact does this have on 32-bit guests which don't have huge amount
of virtual address space?

I think a 32-bit guest could have up to 64 GiB of PFNs, which would
require a 128 MiB p2m array, which is too large?

David
