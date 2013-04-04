Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab3DDJdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:33:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54729 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563Ab3DDJdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:33:06 -0400
Date: Thu, 4 Apr 2013 11:33:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130404093302.GB32271@pd.tnic>
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
 <20130131131805.GG4926@pd.tnic>
 <20130131132400.GH4926@pd.tnic>
 <5130A55E.8030508@suse.cz>
 <515D2C79.7040904@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <515D2C79.7040904@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 09:32:09AM +0200, Jiri Slaby wrote:
> And yesterday I plugged in an ethernet cable for a wihle and guess
> what happened today: Uhhuh. NMI received for unknown reason 2c on CPU
> 0.
>
> Still holds that this is the first time since Jan.

Yeah, you could try my sure-fire way to trigger it:

* boot the box without any "nmi_watchdog" tweaks on the kernel cmdline -
i.e. it should be enabled.

* turn off NMI watchdog through powertop or directly through
/proc/sys/kernel/nmi_watchdog

* suspend to disk

Now when you resume, you should either see unknown reason 2c or 3c.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
