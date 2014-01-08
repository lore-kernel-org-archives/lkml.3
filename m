Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaAHEQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 23:16:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbaAHEQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 23:16:01 -0500
Date: Tue, 7 Jan 2014 20:16:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Tang, Jianqiang" <jianqiang.tang@intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] usb/xhci: avoid kernel panic on xhci_suspend()
Message-ID: <20140108041620.GA9618@kroah.com>
References: <1389145466-8302-1-git-send-email-david.a.cohen@linux.intel.com>
 <20140108014639.GB7823@kroah.com>
 <08C00E7DCA84054D93A5BD962777345A01E2EE3E@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08C00E7DCA84054D93A5BD962777345A01E2EE3E@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Jan 08, 2014 at 03:49:07AM +0000, Tang, Jianqiang wrote:
> Hi,
>  1) I met this issue one time just boot up our Linux Platform(Kernel3.10) with XHCI driver, then kernel panic happen.
> 
>    And this issue reported once by other internal team.
> 
>    Nothing special of reproduce step and do not need special Hardware I think.
> 
>    Just random issue which will happen when meet the timing condition.
> 
>  2) This issue is introduced by this patch:
> 
>      https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=596d789a211d134dc5f94d1e5957248c204ef850
> 
>    which set all hub autosuspend delay to 0.

That patch was released in a kernel almost a full year ago, yet we have
never had a report of this happening before, so are you sure this patch
is the root cause?

>    This causes race condition during XHCI driver initialization,
> 
>     After USB2 hcd and USB2 root hub finish the initialization, USB2 root hub is functional and auto suspend right now, hence trigger XHCI runtime suspend flow;
> 
>     At the same time, XHCI driver continue to initialize the USB3 hcd and assign to xhci->shared_hcd after finish the initialization;
>     
>     Since xhci_suspend() use the xhci->shared_hcd, so there is race condition that when XHCI runtime suspend called, xhci->shared_hcd still NULL.
> 
>     I think this patch is a fix solution since before XHCI finish the whole initialization, USB2 root hub triggered runtime suspend is mean less and do not need to handle.

With this patch applied, does the crash go away?

