Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaHKRkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:40:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:52871 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaHKRkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:40:10 -0400
X-IronPort-AV: E=Sophos;i="5.01,843,1400025600"; 
   d="scan'208";a="161327508"
Message-ID: <53E8FFF8.8070800@citrix.com>
Date: Mon, 11 Aug 2014 18:40:08 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Matt Rushton <mvrushton@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
CC: <msw@amazon.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH v3 2/2] xen/setup: Remap Xen Identity Mapped RAM
References: <1407778441-26604-1-git-send-email-mrushton@amazon.com> <1407778441-26604-2-git-send-email-mrushton@amazon.com>
In-Reply-To: <1407778441-26604-2-git-send-email-mrushton@amazon.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/14 18:34, Matt Rushton wrote:
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

What's changed in this version?

David
