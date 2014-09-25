Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaIYKhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:37:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaIYKhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:37:19 -0400
Date: Thu, 25 Sep 2014 12:36:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Michal Sojka <sojka@merica.cz>, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: Re: [PATCH v6 0/4] LED triggers for USB host and device
Message-ID: <20140925103623.GA28291@kroah.com>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
 <20140924205936.GC17997@saruman>
 <20140924214155.GA30689@kroah.com>
 <20140924221830.GA27914@saruman>
 <20140924231550.GC27672@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924231550.GC27672@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 06:15:50PM -0500, Felipe Balbi wrote:
> On Wed, Sep 24, 2014 at 05:18:30PM -0500, Felipe Balbi wrote:
> > On Wed, Sep 24, 2014 at 11:41:55PM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, Sep 24, 2014 at 03:59:36PM -0500, Felipe Balbi wrote:
> > > > On Wed, Sep 24, 2014 at 10:43:17PM +0200, Michal Sojka wrote:
> > > > > This adds LED triggers for USB host and device. First two patches
> > > > > refactor UDC drivers as requested by Felipe Balbi, the next renames a
> > > > > file and the last is the actual implementation of the LED triggers.
> > > > > 
> > > > > Changes from v5:
> > > > > - Refactoring of USB gadget completion split into two patches (Filipe
> > > > >   Balbi)
> > > > > - Removed check for non-NULL req->completion (Filipe Balbi)
> > > > > 
> > > > > Changes from v4:
> > > > > - Added performance numbers to the commit message of the last patch
> > > > >   (greg k-h).
> > > > > - Replaced BUG_ON with pr_err (Alan Stern, greg k-h).
> > > > > - Used proper coding style for switch statement (greg k-h).
> > > > > - Added comment about NULL argument (greg k-h).
> > > > > - EXPORT_SYMBOL changed to EXPORT_SYMBOL_GPL (greg k-h).
> > > > > - Both triggers are now registerd even if host or gagdet subsystem
> > > > >   is not enabled (Bryan Wu, greg k-h).
> > > > > 
> > > > > Changes from v3:
> > > > > - usb_gadget_giveback_request() moved outside of CONFIG_HAS_DMA
> > > > >   conditioned block.
> > > > > - Added kernel-doc for usb_gadget_giveback_request() (Felipe Balbi).
> > > > > - Removed outdated comment (Alan Stern).
> > > > > - req->complete == NULL is now a bug. Previously, this was ignored
> > > > >   (Alan Stern).
> > > > > - File rename moved to a separate commit (greg k-h).
> > > > > 
> > > > > Changes from v2:
> > > > > - Host/gadget triggers merged to a single file in usb/common/ (Felipe
> > > > >   Balbi).
> > > > > - UDC drivers refactored so that LED trigger works for all of them.
> > > > > 
> > > > > Changes from v1:
> > > > > - Moved from drivers/leds/ to drivers/usb/.
> > > > > - Improved Kconfig help.
> > > > > - Linked with other modules rather than being standalone modules.
> > > > > 
> > > > > Michal Sojka (4):
> > > > >   usb: gadget: Introduce usb_gadget_giveback_request()
> > > > >   usb: gadget: Refactor request completion
> > > > >   usb: Rename usb-common.c
> > > > >   usb: Add LED triggers for USB activity
> > > > 
> > > > Greg, how do you want to handle this one as it touched both host and
> > > > gadget ? I could wait until you apply this series to your usb-next and
> > > > based my pull request on that. That'll work as long as it doesn't take
> > > > too long for this to be merged.
> > > 
> > > I can just take this now, for 3.18-rc1, you've already sent me your
> > > patches for that release, so there shouldn't be any conflicts, right?
> > 
> > that's better. Can you wait 1 day though ? I can run these through my
> > build tests.
> 
> running my build tests on top of v3.17-rc6 + these 4 patches. I'll
> report back tomorrow. From a code perspective, though, they look
> alright.

Yes, will wait, thanks.

greg k-h
