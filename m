Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbaJXPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:09:29 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:50915 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJXPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:09:04 -0400
From: Nix <nix@esperi.org.uk>
To: Johan Hovold <johan@kernel.org>
Cc: Paul Martin <pm@debian.org>, Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <874mwnosz1.fsf@spindle.srvr.nix>
	<871tqe2zqt.fsf_-_@spindle.srvr.nix>
	<20141011195108.GA8275@thinkpad.nowster.org.uk>
	<87y4smz1l0.fsf@spindle.srvr.nix> <20141012185845.GB2786@localhost>
	<878uklynq9.fsf@spindle.srvr.nix> <20141014083432.GB7958@localhost>
	<871tq04fiy.fsf@spindle.srvr.nix> <20141022101458.GK2113@localhost>
	<87y4s8yv38.fsf@spindle.srvr.nix> <20141024111442.GA19377@localhost>
Emacs: the road to Hell is paved with extensibility.
Date: Fri, 24 Oct 2014 16:08:41 +0100
In-Reply-To: <20141024111442.GA19377@localhost> (Johan Hovold's message of
	"Fri, 24 Oct 2014 13:14:42 +0200")
Message-ID: <87bnp1y07a.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Oct 2014, Johan Hovold told this:

> [ +CC: linux-usb ]
> On Wed, Oct 22, 2014 at 04:36:59PM +0100, Nix wrote:
>> On 22 Oct 2014, Johan Hovold outgrape:
>> 
>> > On Wed, Oct 22, 2014 at 10:31:17AM +0100, Nix wrote:
>> >> On 14 Oct 2014, Johan Hovold verbalised:
>> >> 
>> >> > On Sun, Oct 12, 2014 at 10:36:30PM +0100, Nix wrote:
>> >> >> I have checked: this code is being executed against a symlink that
>> >> >> points to /dev/ttyACM0, and the tcsetattr() succeeds. (At least, it's
>> >> >> succeeding on the kernel I'm running now, but of course that's 3.16.5
>> >> >> with this commit reverted...)
>> >> >
>> >> > You could verify that by enabling debugging in the cdc-acm driver and
>> >> > making sure that the corresponding control messages are indeed sent on
>> >> > close.
>> >> 
>> >> I have a debugging dump at
>> >> <http://www.esperi.org.uk/~nix/temporary/cdc-acm.log>; it's fairly
>> >
>> > What kernel were you using here? The log seems to suggest that it was
>> > generated with the commit in question reverted.
>> 
>> Look now :) (the previous log is still there in cdc-acm-reverted.log.)
>
> Unfortunately, it seems the logs are incomplete. There are lots of
> entries missing (e.g. "acm_tty_install" when opening, but also some
> "acm_submit_read_urb"), some of which were there in your first log.

Curious. It's a straight cut-and-paste from the syslog. Maybe the kmsg
buffer overflowed, but I start the ekey daemon *after* I start syslogd,
so that seems unlikely.

I'll have another look.

> Is it only after reboot you've seen the device fail?

Yes (though sometimes after reboot of an unaffected kernel into an
affected one! i.e. sometimes the first boot into an affected kernel is
broken).

>                                                      What if you
> physically disconnect and reconnect the device instead,

That makes it work.

>                                                         or simply
> repeatedly open and close it?

IIRC -- but I'll have to check this tomorrow when I look at the log
problem, so don't take it as gospel -- that doesn't affect it: I can
stop and restart the daemon repeatedly and, if it wasn't working before,
it's not working afterwards: if it was working before, it'll be working
afterwards.

-- 
NULL && (void)
