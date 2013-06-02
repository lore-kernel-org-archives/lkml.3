Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3FBXfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 19:35:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40868 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3FBXfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 19:35:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 3 Jun 2013 01:35:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] firewire: introduce fw_driver.probe and .remove methods
Message-ID: <20130603013502.4df9bc6b@stein>
In-Reply-To: <20130602223843.GA7194@kroah.com>
References: <51A20AEE.7060201@sakamocchi.jp>
	<20130526233513.1a95d0d5@stein>
	<20130526225757.GA32606@kroah.com>
	<51A742A1.8010108@sakamocchi.jp>
	<20130603002749.4fdc36a5@stein>
	<20130602223843.GA7194@kroah.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 02 Greg Kroah-Hartman wrote:
> On Mon, Jun 03, 2013 at 12:27:49AM +0200, Stefan Richter wrote:
> > Although all in-tree drivers are being converted to the new methods,
> > support for the old methods is left in place for the time being, aiming
> > to avoid conflicts if/when new drivers are being merged into the
> > mainline via other trees.
> 
> Are there other firewire drivers in other trees in linux-next right now?
> If not, I'd just recommend converting everything over and not using the
> old functions at all.  Especially as there really isn't that many
> firewire drivers, and new ones are pretty rare these days, right?

I think there is none in -next at the moment.  But Sakamoto-san posted an
RFC just two days ago:
http://mailman.alsa-project.org/pipermail/alsa-devel/2013-June/062614.html

This is one of two(?) drivers on which he is currently working on; the
other one is the one which is going to need the new id argument
in .probe().  And then there is another person working on yet another
sound/firewire/ driver, but upstreaming of that driver might take a
little more time for some more integration steps, from what I heard.

So, alternatively I could fold "firewire: remove support of
fw_driver.driver.probe and .remove methods" into this one and commit it to
a stable topic branch in linux1394.git (to be merged early after 3.10),
and the audio driver developers could pull this topic branch if they want
to and when they want to.

> Other than that, your patch looks good.

Thanks for review.
-- 
Stefan Richter
-=====-===-= -==- ---==
http://arcgraph.de/sr/
