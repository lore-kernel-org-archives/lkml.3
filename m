Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaBKOWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:22:24 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55244 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBKOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:22:23 -0500
Date: Tue, 11 Feb 2014 14:22:03 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jbarnes@virtuousgeek.org, greg@kroah.com
Subject: Baytrail/T (ASUS T100 etc) regression from 3.13 onwards
Message-ID: <20140211142203.77561e0f@alan.etchedpixels.co.uk>
In-Reply-To: <20140114120103.436d190b@alan.etchedpixels.co.uk>
References: <CA+55aFwLXnW-GWKNcUCrpS5e7fd_0ZoKk83H4qMJNUS_WCF_3A@mail.gmail.com>
	<20140114120103.436d190b@alan.etchedpixels.co.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 12:01:03 +0000
One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:

> On Sun, 12 Jan 2014 20:33:03 +0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Another week, another RC. And things look fine.
> 
> It seems to hate Baytrail/T
> 
> My ASUS T100TA has gone from 3.11 'needs video=VGA-1:blah' to get the mode
> right but otherwise running nicely and playing 3D games to 3.13-rc8

This has now been pinned down to (confirmed by multiple people)

commit 6c4a8962a4a078cacfc8eb5d4bd79f6343b8cd7a
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Sep 10 14:54:42 2013 -0700

    drm/i915/vlv: re-enable hotplug detect based probing on VLV/BYT


which given this is affecting some of the top 10 Amazon selling new
laptops and has not been fixed for 3.14-rc should IMHO be reverted until
such time as any needed debugging for the MIPI panels is done for this
driver and the hotplug probing doesn't break the workarounds.

Likewise it wants pulling from any -stable backports.

Alan
