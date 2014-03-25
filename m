Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaCYSuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:50:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaCYSuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:50:03 -0400
Date: Tue, 25 Mar 2014 11:51:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: remove spaces, correct counts to
 unbreak P2P ioctls
Message-ID: <20140325185145.GA4509@kroah.com>
References: <20140325175939.GC17209@kaos.lebenslange-mailadresse.de>
 <20140325181749.GE3233@kroah.com>
 <20140325183618.GD17209@kaos.lebenslange-mailadresse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325183618.GD17209@kaos.lebenslange-mailadresse.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 06:36:18PM +0000, Wilfried Klaebe wrote:
> Am Tue, Mar 25, 2014 at 11:17:49AM -0700 schrieb Greg KH:
> > On Tue, Mar 25, 2014 at 05:59:39PM +0000, Wilfried Klaebe wrote:
> > > staging: rtl8188eu: remove spaces, correct counts to unbreak P2P ioctls
> > > 
> > > It looks like someone did a search-and-replace on that driver, putting
> > > spaces before "=" characters, without checking this is OK everywhere.
> > > Also, in some places, there's memcpm()s/strncmp()s checking for some
> > > different length than the fixed string argument.
> > > 
> > > These things result in code not working as intended. Fix that.
> > 
> > What code is parsing string output from the kernel?
> 
> I know about some userspace apps, for example a MiraCast Sink
> implementation for the Raspberry Pi, called piracast.
> 
> This patch though is about the rtl8188eu driver parsing strings
> handed to it via "iwpriv wlanX p2p_set name=value". Which breaks,
> because the driver checks for "name =" instead of "name=" in several
> cases.

That's horrid on so many levels...
