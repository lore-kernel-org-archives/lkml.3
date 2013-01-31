Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3AaNSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:18:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58182 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3AaNSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:18:11 -0500
Date: Thu, 31 Jan 2013 14:18:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130131131805.GG4926@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20130129202848.GE25415@pd.tnic>
 <5109A8F1.9040707@suse.cz>
 <5109B11C.2010400@suse.cz>
 <5170962.qHnbnlVDfx@vostro.rjw.lan>
 <20130131070926.GC4926@pd.tnic>
 <510A2B1C.1060108@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510A2B1C.1060108@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 09:28:12AM +0100, Jiri Slaby wrote:
> And, does it happen if you switch all of them but NMI wtd in there?

No, but something else happens. Here's the whole dance:

1. Switch all tunables except "NMI watchdog should be turned off" to "Good"
2. suspend to disk
3. resume... all good
4. switch "NMI watchdog should be turned off" to "Good"
5. suspend to disk
6. resume... all good
7. start powertop, toggle "Wireless Power Saving for interface wlan0" twice.
I.e., "Good" -> "Bad"; "Bad" -> "Good".

-> Boom! Unknown reason NMI. It happened right during the toggle because
it appeared in the framebuffer console (no X) right during me toggling
this.

So, it is something getting fishy *after* the watchdog gets disabled.
Something remains funny and dangling, causing it to fire an NMI because
it is an NMI watchdog (doh!)... Could it be that the watchdog_disable
fact doesn't get communicated to the image kernel somehow, or maybe
delayed?

> And if I pass nmi_watchdog=0 to the image kernel, it should be gone I
> guess.

How do you pass options the image kernel?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
