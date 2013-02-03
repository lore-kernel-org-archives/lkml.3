Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3BCVPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:15:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59027 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab3BCVPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:15:21 -0500
Date: Sun, 3 Feb 2013 22:15:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130203211514.GF5844@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20130129202848.GE25415@pd.tnic>
 <2293454.v8QRHr8txR@vostro.rjw.lan>
 <20130203144656.GB5844@pd.tnic>
 <3199697.iYHk9DmIeE@vostro.rjw.lan>
 <20130203205857.GD5844@pd.tnic>
 <20130203210645.GE5844@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130203210645.GE5844@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 10:06:45PM +0100, Borislav Petkov wrote:
> On Sun, Feb 03, 2013 at 09:58:57PM +0100, Borislav Petkov wrote:
> > and it seemed to me that when the eth cable is plugged in, it would
> > suspend and resume fine. When I then boot, unplug the cable, set all
> > tunables to "Good", suspend to disk and resume, no NMI message. When I
> > plug the cable back, only *then* the message triggered.
> > 
> > I need to play with this a bit more to get a better sense of when
> > exactly it happens.
> 
> Ok, not really.
> 
> It is not influenced by the cable being plugged - it happens when I plug
> in the cable or simply shortly after resume, without the cable.

Ok, just did 10 s2ram cycles back-to-back - no issue whatsoever, no
matter when I (un-)plug the cable. Changed the suspend script to

echo "disk" > /sys/power/state

and did an 11th suspend-resume run. It triggered right after resuming
from disk. So I'd guess the image kernel might be the required condition
for the triggering of the issue.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
