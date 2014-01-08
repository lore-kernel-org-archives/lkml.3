Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaAHBqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:46:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaAHBqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:46:10 -0500
Date: Tue, 7 Jan 2014 17:46:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jianqian <jianqiang.tang@intel.com>
Subject: Re: [RFC/PATCH] usb/xhci: avoid kernel panic on xhci_suspend()
Message-ID: <20140108014639.GB7823@kroah.com>
References: <1389145466-8302-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389145466-8302-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 05:44:26PM -0800, David Cohen wrote:
> From: jianqian <jianqiang.tang@intel.com>
> 
> There is a possible kernel panic faced on xhci_suspend().
> Due to kernel modified the hub autosupend_delay to 0s, after usb1 root
> hub finishes initialization, it will trigger runtime_suspend and then
> it will trigger xhci runtime suspend. But at that time, if
> xhci->shared_hcd is still doing initialization, it is possible to face
> null pointer kernel panic in xhci_suspend() function.
> 
> This patch checks if xhci->shared_hcd is null to avoid panic.
> 
> Signed-off-by: jianqian <jianqiang.tang@intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
> 
> This is the kernel panic. The bug was discovered on current LTS kernel 3.10, as
> showed on logs. But the problem does not seem to be fixed so far.
> Maybe we should consider apply it on kernel >= 3.10?

How do you trigger this?  I've never seen anyone report this problem
before, is there something different in the hardware you are using that
enables this to be triggered easier?

thanks,

greg k-h
