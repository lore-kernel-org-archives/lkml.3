Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaJKWZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 18:25:14 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:49314 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaJKWZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 18:25:12 -0400
From: Nix <nix@esperi.org.uk>
To: Paul Martin <pm@debian.org>
Cc: Oliver Neukum <oliver@neukum.org>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <878um4tg09.fsf@spindle.srvr.nix>
	<1409569752.24385.12.camel@linux-fkkt.site>
	<874mwnosz1.fsf@spindle.srvr.nix> <871tqe2zqt.fsf_-_@spindle.srvr.nix>
	<20141011195108.GA8275@thinkpad.nowster.org.uk>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Date: Sat, 11 Oct 2014 23:24:59 +0100
In-Reply-To: <20141011195108.GA8275@thinkpad.nowster.org.uk> (Paul Martin's
	message of "Sat, 11 Oct 2014 20:51:08 +0100")
Message-ID: <87y4smz1l0.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Oct 2014, Paul Martin spake thusly:

> Having been privy to the firmware of the eKey, it is very simplisting,
> with no implementation whatsoever of any flow control.

That's what I thought. (Why would something that just provides data at a
constant rate way below that of even the slowest USB bus *need* flow
control?)

One presumes therefore that the kernel suddenly trying to do flow
control on shutdown would fubar the firmware's internal state, leading
to the symptoms I see.

So, the question becomes, is there a way to spot this general 'no flow
control on this device' thing from the kernel side, or do we need a
blacklist? Or, perhaps, if this is commonplace for cdc-acm devices, a
whitelist? I can't imagine it's *that* commonplace or someone would have
spotted this already in the months and months it took me to do the
bisection.

Maybe all non-modem cdc-acm devices should eschew flow control, or
something? (This is a genuine guess and is almost certainly wrong.)

-- 
NULL && (void)
