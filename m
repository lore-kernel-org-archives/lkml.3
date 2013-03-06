Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab3CFATg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:19:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60202 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3CFATf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:19:35 -0500
Date: Wed, 6 Mar 2013 01:19:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130306001932.GB30189@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	e1000-devel@lists.sourceforge.net,
	Bruce Allan <bruce.w.allan@intel.com>
References: <20130214191234.GH5700@pd.tnic>
 <1362479341.8626.18.camel@jtkirshe-mobl>
 <20130305112737.GE4881@pd.tnic>
 <1372053.VT5YxPEdsx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1372053.VT5YxPEdsx@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 01:13:23AM +0100, Rafael J. Wysocki wrote:
> I suspected that during resume from hibernation the boot kernel (the
> one that loaded the image) did something to hardware and the restored
> kernel didn't handle that change properly. It is hard do say what
> piece of hardware that was, however (it might or might not be the NIC,
> it may be pure coincidence that the NMI messages appear in the log at
> this point).

Agreed with the second part. About the first part, who communicates what
to whom, come to think of it, it might not be related to any devices at
all.

Here's why I think so:

So one of the things I did to trigger this is boot the machine, run
powertop and set all the knobs in the "Tunables" tab to "Good". One of
the tunables is turn-off-nmi-watchdog something which turns off the
watchdog which is using the perf infrastructure which generates NMIs
when the counter overflows.

Now, imagine I do that in the "normal" kernel, then suspend,
...<something happens or does not happen>, then resume back into the
normal kernel and it somehow "forgets" the fact that we disabled the NMI
watchdog before the suspend cycle. And boom, it gets a single spurious
NMI.

Does it make sense? I dunno - I'm just connecting the dots here between
the observation points which are most likely.

Anyway, it's getting late, good night. :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
