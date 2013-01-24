Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161018Ab3AXWFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:05:11 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:39470 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3AXWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:05:07 -0500
Date: Thu, 24 Jan 2013 14:05:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: balbi@ti.com, Venu Byravarasu <vbyravarasu@nvidia.com>,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: host: tegra: make use of PHY pointer of HCD
Message-ID: <20130124220504.GA3833@kroah.com>
References: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com>
 <20130124140504.GA2609@arwen.pp.htv.fi>
 <510167DD.3090001@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510167DD.3090001@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 08:57:01AM -0800, Stephen Warren wrote:
> On 01/24/2013 06:05 AM, Felipe Balbi wrote:
> > Hi,
> > 
> > On Thu, Jan 24, 2013 at 03:57:03PM +0530, Venu Byravarasu wrote:
> >> As pointer to PHY structure can be stored in struct usb_hcd 
> >> making use of it, to call Tegra PHY APIs.
> >> 
> >> Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(), so
> >> that to avoid dereferencing of hcd after its freed up.
> >> 
> >> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com> --- First
> >> version of patch can be found at 
> >> http://marc.info/?l=linux-kernel&m=135581479020213&w=2. As it was
> >> not yet applied, sending v2 of the patch.
> >> 
> >> delta from v1: Modified all Tegra PHY APIs to use standard
> >> 'structu usb_phy *' as their parameter instead of proprietary
> >> parameter of type 'struct tegra_usb_phy *'.
> > 
> > I would like to see those tegra-specific functions vanish from the 
> > driver. Can that be done for v3.10 merge window ?
> 
> Felipe, I assume that means you're OK with me taking this patch for
> 3.9 then?

No objection from me either:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
