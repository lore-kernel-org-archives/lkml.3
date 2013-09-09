Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3IIKep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:34:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:38068 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3IIKeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:34:44 -0400
X-IronPort-AV: E=Sophos;i="4.90,866,1371081600"; 
   d="scan'208";a="49544886"
Message-ID: <522DA442.4050803@citrix.com>
Date: Mon, 9 Sep 2013 11:34:42 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefan.bader@canonical.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>
Subject: Re: [PATCH] Bug-fixes to enable PV ticketlock to work under Xen PVHVM
 with Linux v3.12. (v1)
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/13 14:46, Konrad Rzeszutek Wilk wrote:
> After a bit of false starts, lots of debugging, and tons of help from Stefano and
> David on how event mechanism is suppose to work I am happy to present a set
> of bug-fixes that make PV ticketlocks work under Xen PVHVM with Linux v3.12.
> 
> v3.12 has now thanks to commit 816434ec4a674fcdb3c2221a6dffdc8f34020550
> (Merge branch 'x86-spinlocks-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
> PV ticketlocks. That means:
>  - Xen PV bytelock has been replaced by Xen PV ticketlock.
>  - Xen PVHVM is using ticketlock (not PV variant) - this patch makes it PV.
>  - baremetal is still using ticketlocks.
> 
> In other words everything in the kernel is ticketlock based with the virtualizations
> having the 'PV' part to aid.
> 
> Please take a look at the patches. If you are interested in testing them
> out I will post a git tree on Monday based on v3.11 and v3.12-rc0. 
> 
> Note that I had not run any performance tests and I am not sure when I will
> be able to (got other bugs to squash now). I've asked our internal performance
> engineer to do some benchmarking - but those results won't be available for
> some time as it takes time to do good benchmarking.

If there was favourable performance data I would be happy for these to
go in 3.12, without I think they'll have to wait for 3.13.

David
