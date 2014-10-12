Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaJLS4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 14:56:33 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62835 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaJLS4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 14:56:30 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Sun, 12 Oct 2014 20:58:45 +0200
From: Johan Hovold <johan@kernel.org>
To: Nix <nix@esperi.org.uk>
Cc: Paul Martin <pm@debian.org>, Oliver Neukum <oliver@neukum.org>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141012185845.GB2786@localhost>
References: <878um4tg09.fsf@spindle.srvr.nix>
 <1409569752.24385.12.camel@linux-fkkt.site>
 <874mwnosz1.fsf@spindle.srvr.nix>
 <871tqe2zqt.fsf_-_@spindle.srvr.nix>
 <20141011195108.GA8275@thinkpad.nowster.org.uk>
 <87y4smz1l0.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4smz1l0.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 11:24:59PM +0100, Nix wrote:
> On 11 Oct 2014, Paul Martin spake thusly:
> 
> > Having been privy to the firmware of the eKey, it is very simplisting,
> > with no implementation whatsoever of any flow control.
> 
> That's what I thought. (Why would something that just provides data at a
> constant rate way below that of even the slowest USB bus *need* flow
> control?)
> 
> One presumes therefore that the kernel suddenly trying to do flow
> control on shutdown would fubar the firmware's internal state, leading
> to the symptoms I see.

The cdc-acm driver was dropping DTR/RTS on shutdown (close) also before
the commit you refer to. One thing it did change however is that this is
now only done if HUPCL is set. Might setting that flag be enough to
prevent the device firmware from crashing?

Johan
