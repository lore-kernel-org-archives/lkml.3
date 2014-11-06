Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaKFRO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:14:28 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:60759 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaKFRO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:14:27 -0500
From: Nix <nix@esperi.org.uk>
To: Johan Hovold <johan@kernel.org>
Cc: Paul Martin <pm@debian.org>, Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <20141014083432.GB7958@localhost>
	<871tq04fiy.fsf@spindle.srvr.nix> <20141022101458.GK2113@localhost>
	<87y4s8yv38.fsf@spindle.srvr.nix> <20141024111442.GA19377@localhost>
	<87d298i3y9.fsf@spindle.srvr.nix> <20141105115643.GR31358@localhost>
	<87vbmtbrx2.fsf@spindle.srvr.nix> <20141105181454.GW31358@localhost>
	<877fz8bfs6.fsf@spindle.srvr.nix> <20141106170456.GC26196@localhost>
Emacs: Lovecraft was an optimist.
Date: Thu, 06 Nov 2014 17:14:11 +0000
In-Reply-To: <20141106170456.GC26196@localhost> (Johan Hovold's message of
	"Thu, 6 Nov 2014 18:04:56 +0100")
Message-ID: <87bnok8d5o.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Nov 2014, Johan Hovold said:

> On Thu, Nov 06, 2014 at 01:49:13PM +0000, Nix wrote:
>> On 5 Nov 2014, Johan Hovold told this:
>> > On Wed, Nov 05, 2014 at 03:14:49PM +0000, Nix wrote:
>
>> > Could you try two more things (too make sure line control is really the
>> > culprit):
>> >
>> > 1. If you clear HUPCL in ekeyd so that the lines are never lowered, does
>> > that fix the stability issue?
>> 
>> Definitely not. I got a hang after the first reboot out of an afflicted
>> kernel, when using a HUPCLless ekeyd. Weird. (I guess they're lowered on
>> reboot anyway?)
>
> It's actually only the timings related to the control-lines being raised
> on open that has changed, so this would seem consistent with that.

Urgh. No wonder it was intermittent.

> Thanks for tracking this down. That bisect cannot have been fun given
> the low failure rate (sometimes only one in ten reboots?).

It often failed quite fast, but yes, the negative case was hard to
prove: I had to rewind twice. I counted reboots because I'm a flaming
aspie pedant. 173 reboots that took... thank goodness it replicated on
the machine of mine that's fastest to reboot!

-- 
NULL && (void)
