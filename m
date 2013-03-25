Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816Ab3CYXze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:55:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33712 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209Ab3CYXzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:55:33 -0400
Date: Mon, 25 Mar 2013 23:55:25 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Skeggs <skeggsb@gmail.com>
Subject: Re: Regression: Screen turns off when booting in EFI mode
Message-ID: <20130325235525.GA3423@srcf.ucam.org>
References: <kg69ef$vdb$1@ger.gmane.org>
 <CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
 <5126C3E1.80801@gmail.com>
 <513BACAC.9050800@gmail.com>
 <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
 <20130319195950.GA16828@srcf.ucam.org>
 <CA+55aFy9nbc+9VyCg0BA9E85sRwksQXvu6Wqgurf5omv2mPtZw@mail.gmail.com>
 <5148D5C8.2000701@gmail.com>
 <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 09:52:14AM +1000, Dave Airlie wrote:
> >>> Because it's the only way to get the PCI ROM in some cases, like on
> >>> pretty much all Apples with Radeons. Only using it if we have no other
> >>> options probably makes sense, though. Something like this (entirely
> >>> untested)?
> >>
> >> This looks reasonable. Mantas?
> >
> > It compiles, boots, and even makes the graphics card work again.
> > So it looks good to me.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=927451
> 
> popped up sounds like a regression caused by this.

Sigh. I guess we need to figure out where it thinks it's getting that 
image from. The alternative is basically to go back to what Linus 
suggested, remove this from pci_map_rom() and add an explicit lookup to 
the video drivers.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
