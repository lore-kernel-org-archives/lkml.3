Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3ALQyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 11:54:53 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:57292 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3ALQyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 11:54:51 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Woody Suwalski <terraluna977@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
Date: Sat, 12 Jan 2013 17:54:50 +0100
Message-ID: <7097337.ncPBcd5b1z@linux-5eaq.site>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20130112131602.GA32186@rhlx01.hs-esslingen.de>
References: <20130112131602.GA32186@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2013 14:16:02 Andreas Mohr wrote:
> > Greg, Linus,
> > It sounds insane, but after banging on the issue I have found out that 
> > USB problem is caused (also in vanilla kernel) with a config change:
> > USB-all built as modules - bad USB
> > USB core built in, UHCI/EHCI modules -  semi functional - but 1Mb/s
> > transfer
> > USB core and UHCI EHCI built-in - bingo - no issues.
> > 
> > Could anybody duplicate that, or is it somehow my setup???
> 
> Since there was no additional reply here (needed) so far,
> some of my (questionably relevant?) thoughts on this:
> 
> There's of course the EHCI vs. UHCI(/OHCI) duality
> (EHCI host controller responsible for high speed transfers,
> the other for 1.1 full speed, both serving the same port connectors).
> So if the coordination between the two is a problem,
> you might end up with merely full speed on a 2.0 port.
> 
> And with drivers builtin vs. module, the init sequence/timing
> might possibly be affected - right?

You should try EHCI first. This has always been true, but the likeliehood
of seeing trouble is variable. This is testable.

EHCI static, UHCI modular - should work
EHCI modular, UHCI static - should fail

	Regards
		Oliver

