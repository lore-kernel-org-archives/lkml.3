Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820Ab3CGVPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:15:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176Ab3CGVPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:15:13 -0500
Date: Thu, 7 Mar 2013 16:14:27 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
Message-ID: <20130307211426.GI13719@hansolo.jdub.homelinux.org>
References: <20130307185642.GF13719@hansolo.jdub.homelinux.org>
 <5138E56B.6090308@suse.cz>
 <20130307191005.GH13719@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307191005.GH13719@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 02:10:05PM -0500, Josh Boyer wrote:
> On Thu, Mar 07, 2013 at 08:07:23PM +0100, Jiri Slaby wrote:
> > On 03/07/2013 07:56 PM, Josh Boyer wrote:
> > > commit 835d844d1a28efba81d5aca7385e24c29d3a6db2
> > > Author: Sean Young <sean@mess.org>
> > > Date:   Fri Sep 7 19:06:23 2012 +0100
> > > 
> > >     8250_pnp: do pnp probe before legacy probe
> > > 
> > > but that is simply moving code around.
> > 
> > Hi, not quite. Does it still happen when you revert that one on the top
> > of 3.[789]*?
> 
> That was going to be my first attempt.  I'll let you know how it goes.

Yes, reverting just 835d844d1 on top of 3.7.0 fixes it.  I also see why
now.  That commit changed the module name from 8250 to 8250_core in the
makefile, so clearly 8250.nr_uarts = 16 isn't going to get parsed.
Adding 8250_core.nr_uarts = 16 seems to work fine.  This wasn't
immediately obvious because the whole thing is built-in and not a
module.  Thankfully, looking in /sys/modules/ still works and that
showed up pretty clearly.

So I guess this isn't really a break in functionality as much as it's a
driver rename.  Not sure if it's worth fixing in some form or not.

josh
