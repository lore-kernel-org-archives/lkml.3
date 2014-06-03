Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaFCERj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:17:39 -0400
Received: from linuxhacker.ru ([217.76.32.60]:56408 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaFCERi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:17:38 -0400
Subject: Re: [PATCH] sysctl: Fix division by zero in percpu_pagelist_fraction handler
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <alpine.DEB.2.02.1406022056300.20536@chino.kir.corp.google.com>
Date: Tue, 3 Jun 2014 00:17:23 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Rohit Seth <rohitseth@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2C763027-307F-4BC0-8C0A-7E3D5957A4DA@linuxhacker.ru>
References: <1399166883-514-1-git-send-email-green@linuxhacker.ru> <alpine.DEB.2.02.1406021837490.13072@chino.kir.corp.google.com> <B549468A-10FC-4897-8720-7C9FEC6FD03A@linuxhacker.ru> <alpine.DEB.2.02.1406022056300.20536@chino.kir.corp.google.com>
To: David Rientjes <rientjes@google.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Jun 2, 2014, at 11:57 PM, David Rientjes wrote:
> I'm pretty sure we want to allow users to restore the kernel default 
> behavior if they've already written to this file and now want to change it 
> back.
> 
> What do you think about doing it like this instead?
> ---
> Documentation/sysctl/vm.txt |  3 ++-
> kernel/sysctl.c             |  3 +--
> mm/page_alloc.c             | 20 ++++++++++++--------
> 3 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -702,7 +702,8 @@ The batch value of each per cpu pagelist is also updated as a result.  It is
> set to pcp->high/4.  The upper limit of batch is (PAGE_SHIFT * 8)
> 
> The initial value is zero.  Kernel does not use this value at boot time to set
> -the high water marks for each per cpu page list.
> +the high water marks for each per cpu page list.  If the user writes '0' to this
> +sysctl, it will revert to this default behavior.

I think this is probably a better idea indeed.
Always good to let users return back to defaults too.

Thanks!

