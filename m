Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3FCLb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:31:58 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34450 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab3FCLbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:31:55 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Julius Werner <jwerner@chromium.org>,
        Shawn Nematbakhsh <shawnn@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky controllers.
Date: Mon, 03 Jun 2013 13:33:13 +0200
Message-ID: <1594498.BR3TvGka66@linux-5eaq.site>
User-Agent: KMail/4.10.2 (Linux/3.7.10-1.4-desktop; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130529203238.GC133453@redhat.com>
References: <20130524210503.GC15788@xanatos> <20130529193828.GK32085@xanatos> <20130529203238.GC133453@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 May 2013 16:32:38 Don Zickus wrote:
> On Wed, May 29, 2013 at 12:38:28PM -0700, Sarah Sharp wrote:
> > On Tue, May 28, 2013 at 02:41:18PM -0700, Julius Werner wrote:
> > > The policy we want to achieve is to disable runtime PM iff there is a
> > > device connected that doesn't have persist_enabled or a reset_resume()
> > > handler and whose parent/root hub resets on resume, right?
> > 
> > Makes sense.  However, not all distros may want that policy, so there
> > should be a way to change that policy via sysfs.  Some distros may
> > choose to take the power savings over having a particular USB device
> > work, especially in the server market.
> > 
> > Don, Oliver, what do you think of this patch:
> > http://marc.info/?l=linux-usb&m=136941922715772&w=2
> 
> That is limited only to certain controllers right?  RHEL6 doesn't support
> runtime suspend, so we don't hear to many complaints.  Most of our server
> customers don't have much plugged into USB, so I don't expect much
> problems there.  Our laptop customers prefer the power savings, but I
> don't know how many of them have chipsets with XHCI_RESET_ON_RESUME.

Power savings are good, but reliability is better. For what it's worth,ior
I like the patch. It is a logical extension of the current behavior.

	Regards
		Oliver

