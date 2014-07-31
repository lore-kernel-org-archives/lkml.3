Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaGaRoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:44:01 -0400
Received: from smtp.citrix.com ([66.165.176.89]:60062 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaGaRoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:44:00 -0400
X-IronPort-AV: E=Sophos;i="5.01,773,1400025600"; 
   d="scan'208";a="157609883"
Message-ID: <53DA805D.4020300@citrix.com>
Date: Thu, 31 Jul 2014 18:43:57 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Matt Rushton <mvrushton@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
CC: <msw@amazon.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH v2 2/2] xen/setup: Remap Xen Identity Mapped RAM
References: <1405814495-10868-1-git-send-email-mrushton@amazon.com> <1405814495-10868-2-git-send-email-mrushton@amazon.com>
In-Reply-To: <1405814495-10868-2-git-send-email-mrushton@amazon.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/14 01:01, Matt Rushton wrote:
> Instead of ballooning up and down dom0 memory this remaps the existing mfns
> that were replaced by the identity map. The reason for this is that the
> existing implementation ballooned memory up and and down which caused dom0
> to have discontiguous pages. In some cases this resulted in the use of bounce
> buffers which reduced network I/O performance significantly. This change will
> honor the existing order of the pages with the exception of some boundary
> conditions.
> 
> To do this we need to update both the Linux p2m table and the Xen m2p table.
> Particular care must be taken when updating the p2m table since it's important
> to limit table memory consumption and reuse the existing leaf pages which get
> freed when an entire leaf page is set to the identity map. To implement this,
> mapping updates are grouped into blocks with table entries getting cached
> temporarily and then released.
> 
> On my test system before:
> Total pages: 2105014
> Total contiguous: 1640635
> 
> After:
> Total pages: 2105014
> Total contiguous: 2098904

Applied to devel/for-linus-3.17

Thanks.

David
