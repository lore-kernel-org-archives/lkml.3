Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3AaHJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:09:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55371 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3AaHJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:09:31 -0500
Date: Thu, 31 Jan 2013 08:09:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130131070926.GC4926@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20130129202848.GE25415@pd.tnic>
 <5109A8F1.9040707@suse.cz>
 <5109B11C.2010400@suse.cz>
 <5170962.qHnbnlVDfx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5170962.qHnbnlVDfx@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 01:54:56AM +0100, Rafael J. Wysocki wrote:
> On Thursday, January 31, 2013 12:47:40 AM Jiri Slaby wrote:
> > On 01/31/2013 12:12 AM, Jiri Slaby wrote:
> > > I think I will start with commenting parts of `power' script to see
> > > exactly which of the power savings cause this.
> > 
> > ... NMI watchdog. If I remove it from the script, the problem
> > disappears. If I try it alone, I have those NMIs.
> 
> Well, beats me. :-(
> 
> I suspect that it doesn't quiesce itself sufficiently before image restoration
> and we get some crosstalk between the boot kernel and the image kernel.

Well, I did what Jiri said causes it:

echo 0 > /proc/sys/kernel/nmi_watchdog

No NMI.

BUT(!), if I start powertop and set all tunables in the "Tunables" tab
to "Good", then suspend to disk, when I resume I get the NMI and this
time the unknown reason is 0x3c. Sounds like this needs bisection...
Btw, this is latest -rc5 + tip/master and Jiri triggers it on 3.7-stable
...

Btw, this e1000e thing has another problem: when I unplug the network
cable and replug it again, it cannot ping local network anymore.
Normally, when you plug the network cable back in, it does some sort if
link detection saying eth link is back up but it doesn't say it on that
box - only a reboot fixes it. Hmm.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
