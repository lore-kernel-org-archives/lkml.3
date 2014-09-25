Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaIYSGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:06:51 -0400
Received: from cloud.peff.net ([50.56.180.127]:51717 "HELO cloud.peff.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753559AbaIYSGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:06:49 -0400
Date: Thu, 25 Sep 2014 14:00:05 -0400
From: Jeff King <peff@peff.net>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Sojka <sojka@merica.cz>, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz,
        git <git@vger.kernel.org>
Subject: Re: project wide: git config entry for [diff] renames=true
Message-ID: <20140925180005.GA11755@peff.net>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
 <1411591401-5874-4-git-send-email-sojka@merica.cz>
 <20140925150353.GA15325@kroah.com>
 <1411660111.4026.24.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411660111.4026.24.camel@joe-AO725>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 08:48:31AM -0700, Joe Perches wrote:

> On Thu, 2014-09-25 at 17:03 +0200, Greg Kroah-Hartman wrote:
> 
> > In the future, please generate a git "move" diff, which makes it easier
> > to review, and prove that nothing really changed.  It also helps if the
> > file is a bit different from what you diffed against, which in my case,
> > was true.
> 
> Maybe it'd be possible to add 
> 
> [diff]
> 	renames = true
> 
> to the .git/config file.
> 
> but I don't find a mechanism to add anything to the
> .git/config and have it be pulled.

There is no such mechanism within git. We've resisted adding one because
of the danger of something like:

  [diff]
    external = rm -rf /

diff.renames is probably safe, but any config-sharing mechanism would
have to deal with either whitelisting, or providing some mechanism for
the puller to review changes before blindly following them.

-Peff
