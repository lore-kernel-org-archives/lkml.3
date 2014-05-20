Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaETTvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:51:53 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:36511 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaETTvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:51:51 -0400
Date: Tue, 20 May 2014 13:51:40 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 4/9] of: mtd: add documentation for the ONFI NAND
 timing mode property
Message-ID: <20140520195140.GA32287@obsidianresearch.com>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
 <1394647664-8258-5-git-send-email-b.brezillon.dev@gmail.com>
 <20140520182542.GS28907@ld-irv-0074>
 <537BAD59.3060902@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537BAD59.3060902@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 09:30:33PM +0200, Boris BREZILLON wrote:

> AFAICT nothing, but the same goes for the ECC requirements, and we've
> recently added DT bindings to define these requirements.
> I'm not telling we should drop these ECC requirements bindings (actually
> I'm using them :-)), but what's different with the timings requirements ?

ECC requirements are almost always something that has to be matched to
the bootloader (since the bootloader typicaly reads the NAND to boot),
so it is sensible to put that in the DT

The timings are a property of the chip, and if they can be detected
they should be. IMHO, the main purpose of a DT property would be to
lower the speed if, for some reason, the board cannot support the
device's full speed.

> Indeed, I based it on the ONFI NAND timings mode model, but AFAIK
> (tell me if I'm wrong), it should work because most of the timings
> are min requirements.  This means, even if you provide slower
> signals transitions, the NAND will work as expected.

IIRC for ONFI a device must always work in the mode 0 timings, without
requiring a command?

Jason
