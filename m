Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3AaNXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:23:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36171 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab3AaNXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:23:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Date: Thu, 31 Jan 2013 14:29:53 +0100
Message-ID: <8449445.ZpDikfZkfG@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130131131805.GG4926@pd.tnic>
References: <20130129202848.GE25415@pd.tnic> <510A2B1C.1060108@suse.cz> <20130131131805.GG4926@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 31, 2013 02:18:05 PM Borislav Petkov wrote:
> On Thu, Jan 31, 2013 at 09:28:12AM +0100, Jiri Slaby wrote:
> > And, does it happen if you switch all of them but NMI wtd in there?
> 
> No, but something else happens. Here's the whole dance:
> 
> 1. Switch all tunables except "NMI watchdog should be turned off" to "Good"
> 2. suspend to disk
> 3. resume... all good
> 4. switch "NMI watchdog should be turned off" to "Good"
> 5. suspend to disk
> 6. resume... all good
> 7. start powertop, toggle "Wireless Power Saving for interface wlan0" twice.
> I.e., "Good" -> "Bad"; "Bad" -> "Good".
> 
> -> Boom! Unknown reason NMI. It happened right during the toggle because
> it appeared in the framebuffer console (no X) right during me toggling
> this.
> 
> So, it is something getting fishy *after* the watchdog gets disabled.
> Something remains funny and dangling, causing it to fire an NMI because
> it is an NMI watchdog (doh!)... Could it be that the watchdog_disable
> fact doesn't get communicated to the image kernel somehow, or maybe
> delayed?

The image kernel has no idea whether or not the watchdog has been disabled in
the boot kernel.  It needs to be disabled in both.

> 
> > And if I pass nmi_watchdog=0 to the image kernel, it should be gone I
> > guess.
> 
> How do you pass options the image kernel?

The image kernel has the same set of command line options that was used by
that kernel before hibernation.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
