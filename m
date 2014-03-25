Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaCYSpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:45:00 -0400
Received: from mail0.toppoint.de ([217.70.197.20]:55548 "EHLO
	mail0.toppoint.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaCYSo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:44:59 -0400
Date: Tue, 25 Mar 2014 18:36:18 +0000
From: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: remove spaces, correct counts to
 unbreak P2P ioctls
Message-ID: <20140325183618.GD17209@kaos.lebenslange-mailadresse.de>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20140325175939.GC17209@kaos.lebenslange-mailadresse.de>
 <20140325181749.GE3233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325181749.GE3233@kroah.com>
X-message-flag: Get yourself a real email client. http://www.mutt.org/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, Mar 25, 2014 at 11:17:49AM -0700 schrieb Greg KH:
> On Tue, Mar 25, 2014 at 05:59:39PM +0000, Wilfried Klaebe wrote:
> > staging: rtl8188eu: remove spaces, correct counts to unbreak P2P ioctls
> > 
> > It looks like someone did a search-and-replace on that driver, putting
> > spaces before "=" characters, without checking this is OK everywhere.
> > Also, in some places, there's memcpm()s/strncmp()s checking for some
> > different length than the fixed string argument.
> > 
> > These things result in code not working as intended. Fix that.
> 
> What code is parsing string output from the kernel?

I know about some userspace apps, for example a MiraCast Sink
implementation for the Raspberry Pi, called piracast.

This patch though is about the rtl8188eu driver parsing strings
handed to it via "iwpriv wlanX p2p_set name=value". Which breaks,
because the driver checks for "name =" instead of "name=" in several
cases.

Regards,
Wilfried

