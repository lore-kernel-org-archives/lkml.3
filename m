Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaJQMfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:35:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25286 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaJQMfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:35:21 -0400
X-IronPort-AV: E=Sophos;i="5.04,739,1406592000"; 
   d="scan'208";a="183520553"
Message-ID: <54410D06.3010109@citrix.com>
Date: Fri, 17 Oct 2014 13:35:18 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH V2] xen: avoid race in p2m handling
References: <1413544566-12250-1-git-send-email-jgross@suse.com>
In-Reply-To: <1413544566-12250-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/14 12:16, Juergen Gross wrote:
> When a new p2m leaf is allocated this leaf is linked into the p2m tree
> via cmpxchg. Unfortunately the compare value for checking the success
> of the update is read after checking for the need of a new leaf. It is
> possible that a new leaf has been linked into the tree concurrently
> in between. This could lead to a leaked memory page and to the loss of
> some p2m entries.
> 
> Avoid the race by using the read compare value for checking the need
> of a new p2m leaf and use ACCESS_ONCE() to get it.
> 
> There are other places which seem to need ACCESS_ONCE() to ensure
> proper operation. Change them accordingly.

Applied, thanks.

David
