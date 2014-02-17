Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaBQPy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:54:29 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60177 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaBQPy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:54:27 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>, keescook@chromium.org,
        devicetree@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20140212182000.GJ5554@obsidianresearch.com>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org> < 201402121251.06280.arnd@arndb.de> <20140212174554.GM27395@titan.lakedaemon. net> <20140212182000.GJ5554@obsidianresearch.com>
Date: Mon, 17 Feb 2014 15:54:19 +0000
Message-Id: <20140217155419.682F7C401D4@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014 11:20:00 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> On Wed, Feb 12, 2014 at 12:45:54PM -0500, Jason Cooper wrote:
> 
> > The bootloader would then load this file into ram, and pass the
> > address/size to the kernel either via dt, or commandline.  kaslr (run in
> > the decompressor) would consume some of this randomness, and then
> > random.c would consume the rest in a non-crediting initialization.
> 
> Sure is a neat idea, but I think in general it would probably be smart
> to include the entire FDT blob in the early random pool, that way you
> get MACs and other machine unique data too.

I applied a patch that did exactly that (109b623629), and then reverted
it (b920ecc82) shortly thereafter because add_device_randomness() is
a rather slow function and FDTs can get large. I'd like to see someone
do a reasonable analysis on the cost of using an FDT for randomness
before I reapply a patch doing something similar. An awful lot of the
FDT data is not very random, but there are certainly portions of it that
are appropriate for the random pool.

g.
