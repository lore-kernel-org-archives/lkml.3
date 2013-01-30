Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3A3VdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:33:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34346 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab3A3VdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:33:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Date: Wed, 30 Jan 2013 22:39:12 +0100
Message-ID: <2240511.0oyl5pIt1j@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51098397.5040206@suse.cz>
References: <20130129202848.GE25415@pd.tnic> <20130130200041.GD23895@pd.tnic> <51098397.5040206@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 30, 2013 09:33:27 PM Jiri Slaby wrote:
> On 01/30/2013 09:00 PM, Borislav Petkov wrote:
> > On Wed, Jan 30, 2013 at 08:43:55PM +0100, Jiri Slaby wrote:
> >> On 01/30/2013 06:44 PM, Borislav Petkov wrote:
> >>> On Wed, Jan 30, 2013 at 10:27:42AM -0700, Bjorn Helgaas wrote:
> >>>> You're right, I don't think we're quite ready to merge those patches.
> >>>> But if your NMI is easy to reproduce, it might be worth removing
> >>>> e1000e altogether to see if it still happens.
> >>>
> >>> That's the problem - I've seen it only once so far. I'll watch out for
> >>> it and do the above when I find a reliable way of reproducing it. Will
> >>> keep you posted.
> >>
> >> It happens here too. Dunno what is the root cause. I *think* that it
> >> never happened unless I used ethernet. Other than that I see no pattern.
> >>
> >> Attaching -C 20 grep of messages over the last half year if there is
> >> something that may help somehow.
> > 
> > Cool, so it happens once a day, not every day, everytime during resume,
> > and with e1000e. Can you try Bjorn's suggestion to remove e1000e
> > altogether and see if it still happens?
> 
> No, e1000e is not to blame at all. I moved e1000e out of /lib/modules
> and it still happens.
> 
> What is cool is that I have steps to reproduce:
> 1) boot
> 2) run the attached script (turn on all possible power savings -- in
> fact everything what powertop suggests)
> 3) suspend to _disk_ (mem is not enough, BIOS apparently has to
> interfere here)

No, I don't think it's the BIOS.  Most likely the boot kernel.

> 4) resume from disk
> 5) boom
> 
> I tried to remove also wireless drivers, no change.

Is the resume boot kernel the same as the one in the image?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
