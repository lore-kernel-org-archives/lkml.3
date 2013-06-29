Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3F2XUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:20:43 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59856 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3F2XUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:20:41 -0400
Date: Sat, 29 Jun 2013 16:20:38 -0700
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130629232038.GA12533@quad.lixom.net>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
 <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
 <20130628200333.GA2756@lukather>
 <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
 <20130629193819.GD3353@n2100.arm.linux.org.uk>
 <20130629225426.GA12221@quad.lixom.net>
 <20130629231425.GG3353@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629231425.GG3353@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 30, 2013 at 12:14:26AM +0100, Russell King - ARM Linux wrote:
> On Sat, Jun 29, 2013 at 03:54:26PM -0700, Olof Johansson wrote:
> > Most of this ruffle seems to be about the fact that booting a kernel
> > with a device tree that doesn't conform to the brand spanking new,
> > and never previously enforced, binding for the cpu nodes will produce
> > a WARN_ON(). Lots of our in-tree device trees fall into this category.
> > 
> > And while I think it was a bad idea for Lorenzo to ask for this to be
> > merged as a fix this late (and most in particular for stable), as far
> > as I can tell nothing (new) is broken by it -- just the alarming warning
> > is being printed.
> > 
> > I think it probably makes sense to downgrade the WARN to just a printk, and
> > people will be a lot less worried. How about the below?
> > 
> > If you're OK with it, Russell, can we get your ack so Linus can apply
> > directly given the imminence of final 3.10? Or, if you prefer, you can of
> > course apply and send it on instead.
> 
> You can have my usual rmk+kernel ack for it with one change...
> 
> > +	if (!bootcpu_valid) {
> > +		pr_warn("DT missing boot CPU MPIDR[23:0], fall back to "
> > +			"default cpu_logical_map\n");
> 
> Don't wrap messages kernel messages inspite of what checkpatch says.
> Always keep messages like that on a single line so they're greppable.
> Checkpatch is far from perfect and does get stuff wrong, and this is
> one of its common mistakes.

I didn't even run it through checkpatch, and I prefer greppable strings too --
I just went with what the rest of the file already used in this case to keep
the change minimal given timing.

I'll send a fresh copy with your ack and the above changed. Thanks.


-Olof

