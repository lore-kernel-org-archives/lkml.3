Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3BCU7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 15:59:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58195 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab3BCU7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 15:59:04 -0500
Date: Sun, 3 Feb 2013 21:58:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130203205857.GD5844@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20130129202848.GE25415@pd.tnic>
 <2293454.v8QRHr8txR@vostro.rjw.lan>
 <20130203144656.GB5844@pd.tnic>
 <3199697.iYHk9DmIeE@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3199697.iYHk9DmIeE@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 09:15:12PM +0100, Rafael J. Wysocki wrote:
> Is suspend-to-RAM triggering that as too?

Nope, not really. But, just to confirm: s2r is

echo "shutdown" > /sys/power/disk
echo "mem" > /sys/power/state

right?

Btw, this bug is very strange. So I did a couple more s2disk runs, i.e.

echo "shutdown" > /sys/power/disk
echo "disk" > /sys/power/state

and it seemed to me that when the eth cable is plugged in, it would
suspend and resume fine. When I then boot, unplug the cable, set all
tunables to "Good", suspend to disk and resume, no NMI message. When I
plug the cable back, only *then* the message triggered.

I need to play with this a bit more to get a better sense of when
exactly it happens.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
