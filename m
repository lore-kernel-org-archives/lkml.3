Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966870Ab3E2Ucz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:32:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966083Ab3E2Ucp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:32:45 -0400
Date: Wed, 29 May 2013 16:32:38 -0400
From: Don Zickus <dzickus@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Shawn Nematbakhsh <shawnn@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky
 controllers.
Message-ID: <20130529203238.GC133453@redhat.com>
References: <20130524210503.GC15788@xanatos>
 <Pine.LNX.4.44L0.1305251005390.18146-100000@netrider.rowland.org>
 <CALaWCOOGEDtF1z29df2ST9kV-VpMa9VbvFK0Hh71WJG5f_pngA@mail.gmail.com>
 <20130528205842.GE32085@xanatos>
 <CAODwPW8ynh3238T6gOVmneMqsbdR2m+wPnVLbS7c38mQxCpBSQ@mail.gmail.com>
 <20130529193828.GK32085@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529193828.GK32085@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 12:38:28PM -0700, Sarah Sharp wrote:
> On Tue, May 28, 2013 at 02:41:18PM -0700, Julius Werner wrote:
> > The policy we want to achieve is to disable runtime PM iff there is a
> > device connected that doesn't have persist_enabled or a reset_resume()
> > handler and whose parent/root hub resets on resume, right?
> 
> Makes sense.  However, not all distros may want that policy, so there
> should be a way to change that policy via sysfs.  Some distros may
> choose to take the power savings over having a particular USB device
> work, especially in the server market.
> 
> Don, Oliver, what do you think of this patch:
> http://marc.info/?l=linux-usb&m=136941922715772&w=2

That is limited only to certain controllers right?  RHEL6 doesn't support
runtime suspend, so we don't hear to many complaints.  Most of our server
customers don't have much plugged into USB, so I don't expect much
problems there.  Our laptop customers prefer the power savings, but I
don't know how many of them have chipsets with XHCI_RESET_ON_RESUME.

> 
> Julius is proposing to limit the scope of the patch a bit, but the
> impact will still be that TI hosts will be active more often than not.

Hmm, for some reason I don't see TI having the XHCI_RESET_ON_RESUME quirk
set, just VIA and ETRON.  Neither of which seem to be normally shipped
with servers.

Cheers,
Don
