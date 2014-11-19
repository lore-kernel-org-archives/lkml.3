Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaKSQ77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:59:59 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55404 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaKSQ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:59:58 -0500
Date: Wed, 19 Nov 2014 16:59:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
Message-ID: <20141119165948.GM4042@n2100.arm.linux.org.uk>
References: <20141118173413.GB4042@n2100.arm.linux.org.uk>
 <546B8C64.3010904@samsung.com>
 <2041617.Kxhx5O4MMr@wuerfel>
 <CAKv+Gu-8qhHYOry+LsDzp+LDZqYxVZ5G7cj48E3G2Unp2+=_yg@mail.gmail.com>
 <CALYGNiMt2A3DP02cOtxqu4RrnmhojrDxkRG7bkHMByUnzG+PeA@mail.gmail.com>
 <CAKv+Gu-rYWutr-45MsZH6KOhhUyNCVLfkO9JQrqCm1L6ms_DUg@mail.gmail.com>
 <20141119160747.GH4042@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1411191130480.11690@knanqh.ubzr>
 <20141119164902.GK4042@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1411191152340.11690@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1411191152340.11690@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:57:15AM -0500, Nicolas Pitre wrote:
> On Wed, 19 Nov 2014, Russell King - ARM Linux wrote:
> > I don't think I ever did, because its pretty much impossible to do as I
> > explained in a follow up to this thread.
> > 
> > We _used_ to do this with the userspace insmod methods, but since we got
> > this kernel-side linker, it's been pretty much impossible to do without
> > rewriting the module code.  That's not going to happen on account of one
> > quirky architecture which Linus doesn't particularly like.
> 
> Still... We could try adding a hook in the generic module linker code 
> for a pre-relocation pass.  Maybe only ARM would use it, but if the need 
> to load big modules is real then I imagine Linus could be amenable to a 
> compromise.

So, how big a table would you allocate for the trampolines, based upon
not knowing anything about the module being loaded?  4K?  8K?  64K?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
