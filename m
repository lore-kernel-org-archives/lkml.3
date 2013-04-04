Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3DDJ62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:58:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53709 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759383Ab3DDJ61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:58:27 -0400
Date: Thu, 4 Apr 2013 11:58:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130404095823.GC32271@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <5109B11C.2010400@suse.cz>
 <5170962.qHnbnlVDfx@vostro.rjw.lan>
 <20130131070926.GC4926@pd.tnic>
 <510A2B1C.1060108@suse.cz>
 <20130131131805.GG4926@pd.tnic>
 <20130131132400.GH4926@pd.tnic>
 <5130A55E.8030508@suse.cz>
 <515D2C79.7040904@suse.cz>
 <20130404093302.GB32271@pd.tnic>
 <515D4A0D.7070302@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <515D4A0D.7070302@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 11:38:21AM +0200, Jiri Slaby wrote:
> Oh, this reminds me that this time it might be unrelated to
> yesterday's use of ethernet. Because today, I resumed the system by a
> kernel which I didn't pass nmi_watchdog=0 to.
>
> Hmm. So you can silently ignore the report I sent today :).
>
> And sure, the way you describe above "works" for me to trigger the
> issue... I just wanted to note the ethernet may interfere.
>
> Anyway, I will bake some hack to disable NMI before jumping to the
> resumed kernel and will see what happens...

Yeah, Rafael said something about the resume kernel not getting the
disabling of the watchdog in time or so... The issue looks like a last
forgotten NMI which fires although we've disabled the watchdog already.
The certainly aren't any other coming up after this last one.

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
