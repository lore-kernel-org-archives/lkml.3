Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaETTzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:55:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47338 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaETTzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:55:08 -0400
Date: Tue, 20 May 2014 12:55:04 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 4/9] of: mtd: add documentation for the ONFI NAND
 timing mode property
Message-ID: <20140520195504.GX28907@ld-irv-0074>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
 <1394647664-8258-5-git-send-email-b.brezillon.dev@gmail.com>
 <20140520182542.GS28907@ld-irv-0074>
 <537BAD59.3060902@free-electrons.com>
 <20140520195140.GA32287@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520195140.GA32287@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 01:51:40PM -0600, Jason Gunthorpe wrote:
> On Tue, May 20, 2014 at 09:30:33PM +0200, Boris BREZILLON wrote:
> > AFAICT nothing, but the same goes for the ECC requirements, and we've
> > recently added DT bindings to define these requirements.
> > I'm not telling we should drop these ECC requirements bindings (actually
> > I'm using them :-)), but what's different with the timings requirements ?
> 
> ECC requirements are almost always something that has to be matched to
> the bootloader (since the bootloader typicaly reads the NAND to boot),
> so it is sensible to put that in the DT

+1 You beat me to this :)

> The timings are a property of the chip, and if they can be detected
> they should be. IMHO, the main purpose of a DT property would be to
> lower the speed if, for some reason, the board cannot support the
> device's full speed.

Agreed.

Now, we still have the open question of whether we can autodetect timing
modes easily for non-ONFI chips.

> > Indeed, I based it on the ONFI NAND timings mode model, but AFAIK
> > (tell me if I'm wrong), it should work because most of the timings
> > are min requirements.  This means, even if you provide slower
> > signals transitions, the NAND will work as expected.
> 
> IIRC for ONFI a device must always work in the mode 0 timings, without
> requiring a command?

I believe so.

FYI, despite the name of the binding, we are mostly interested in
non-ONFI NAND here.

Brian
