Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaJLLOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:14:15 -0400
Received: from bethyngalw.nowster.me.uk ([92.243.21.240]:34537 "EHLO
	bethyngalw.nowster.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJLLOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:14:11 -0400
Date: Sun, 12 Oct 2014 12:14:05 +0100
From: Paul Martin <pm@debian.org>
To: Nix <nix@esperi.org.uk>
Cc: Oliver Neukum <oliver@neukum.org>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Daniel Silverstone <dsilvers@debian.org>
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141012111405.GB8275@thinkpad.nowster.org.uk>
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
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 11:24:59PM +0100, Nix wrote:
> On 11 Oct 2014, Paul Martin spake thusly:
> 
> > Having been privy to the firmware of the eKey, it is very simplistic,
> > with no implementation whatsoever of any flow control.
> 
> That's what I thought. (Why would something that just provides data at a
> constant rate way below that of even the slowest USB bus *need* flow
> control?)
> 
> One presumes therefore that the kernel suddenly trying to do flow
> control on shutdown would fubar the firmware's internal state, leading
> to the symptoms I see.
> 
> So, the question becomes, is there a way to spot this general 'no flow
> control on this device' thing from the kernel side, or do we need a
> blacklist? Or, perhaps, if this is commonplace for cdc-acm devices, a
> whitelist? I can't imagine it's *that* commonplace or someone would have
> spotted this already in the months and months it took me to do the
> bisection.
> 
> Maybe all non-modem cdc-acm devices should eschew flow control, or
> something? (This is a genuine guess and is almost certainly wrong.)
> 

I'm going to pass this on to Daniel Silverstone, who did the actual
coding of the firmware.

-- 
Paul Martin <pm@debian.org>
