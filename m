Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaJ0VV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:21:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41336 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaJ0VV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:21:58 -0400
Date: Mon, 27 Oct 2014 22:21:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
Message-ID: <20141027212155.GB3755@amd>
References: <CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
 <544033CF.3080104@gaast.net>
 <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
 <5442FE58.5020700@gaast.net>
 <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
 <5446D2D8.2090203@gaast.net>
 <CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
 <20141022125354.GA3832@gaast.net>
 <CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com>
 <544E235C.5010908@gaast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544E235C.5010908@gaast.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-10-27 10:50:04, Wilmer van der Gaast wrote:
> Hello Yinghai,
> 
> Thanks again for your time!
> 
> I've applied your two patches, and as a wild guess also added pci=dump to my
> kernel cmdline though I guess that just gave me a boot-time dump - which
> mostly didn't make it into my dmesg.
> 
> I accidentally booted with no_console_suspend on the first run, which still
> caused no output at all on the failed resume. I'm including the output of
> that anyway, but also I have a run with that flag removed, and annoyingly
> the crash appears to happen before the dump during the crash finishes -
> while dumping info for this device, it seems:
> 
> 04:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892 (rev 10)
> (prog-if 01 [Subtractive decode])
> 
> (More info in my lspci.txt)
> 
> Wondering what device that is exactly, I stumbled upon
> http://sourceforge.net/p/linux1394/mailman/message/29755048/ where someone
> describes it as a "cheap and crappy PCI bridge". More and more I wonder if I
> should just buy a new motherboard - sadly this one wasn't even that
> cheap.

It is probably not just you that is affected, and we already know what
change broke it. So we really should fix it.

> :-( Though I don't know if the output stopping while dumping output for this
> device means that it is the culprit, is printk() to the serial console in
> any way blocking/buffered?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
