Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3CEJ61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:58:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33598 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab3CEJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:58:24 -0500
Date: Tue, 5 Mar 2013 10:58:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130305095821.GC4881@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	e1000-devel@lists.sourceforge.net,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	Bruce Allan <bruce.w.allan@intel.com>
References: <2293454.v8QRHr8txR@vostro.rjw.lan>
 <20130203144656.GB5844@pd.tnic>
 <20130214143905.GC5700@pd.tnic>
 <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com>
 <20130214191234.GH5700@pd.tnic>
 <511DF7B4.8060504@openvz.org>
 <20130215091641.GA14387@pd.tnic>
 <20130304215056.GG22274@pd.tnic>
 <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com>
 <5135BDF9.3080102@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5135BDF9.3080102@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 10:42:17AM +0100, Jiri Slaby wrote:
> On 03/05/2013 01:16 AM, Bjorn Helgaas wrote:
> > [+cc e1000-devel, Jeff, Bruce]
> > 
> > On Mon, Mar 4, 2013 at 2:50 PM, Borislav Petkov <bp@alien8.de> wrote:
> >> On Fri, Feb 15, 2013 at 10:16:41AM +0100, Borislav Petkov wrote:
> >>> So it looks Bjorn has taken most of them and the e1000e one will go
> >>> through the e1000e maintainers. I'll test after the merge window is
> >>> done.
> >>
> >> Issue still persists on 3.9-rc1 :-( :
> >>
> >> Mar  4 21:47:34 nazgul vmunix: [ 3223.412541] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> >> Mar  4 21:47:34 nazgul vmunix: [ 3223.412554] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
> >> Mar  4 21:47:35 nazgul vmunix: [ 3224.034158] Uhhuh. NMI received for unknown reason 2c on CPU 0.
> >> Mar  4 21:47:35 nazgul vmunix: [ 3224.034166] Do you have a strange power saving mode enabled?
> >> Mar  4 21:47:35 nazgul vmunix: [ 3224.034168] Dazed and confused, but trying to continue
> > 
> > The e1000e changes didn't get merged, did they?  I don't see the
> > following changes mentioned at https://lkml.org/lkml/2013/2/4/185 in
> > 3.9-rc1:
> > 
> >       e1000e: fix pci-device enable-counter balance
> >       e1000e: fix runtime power management transitions
> >       e1000e: fix accessing to suspended device
> 
> You're right. They are not even in -next :(.

Oh, and there's another issue with this driver I reported yesterday:
http://marc.info/?l=linux-kernel&m=136243374114892&w=2:

"Trying to free already-free IRQ 20"

which happens during suspend so it seems also related.

Rafael, what's the state of those patches here:
https://lkml.org/lkml/2013/2/4/185, are they ready to be tested or you
still have issues with them?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
