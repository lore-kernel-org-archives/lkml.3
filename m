Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbaBRJjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:39:52 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44963 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaBRJjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:39:48 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>, keescook@chromium.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1418981.0py7JxXCp8@wuerfel>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org> < 201402121251.06280.arnd@arndb.de> <20140217155419.682F7C401D4@trevor. secretlab.ca> <1418981.0py7JxXCp8@wuerfel>
Date: Tue, 18 Feb 2014 09:39:40 +0000
Message-Id: <20140218093940.7A822C403C8@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014 17:13:07 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 17 February 2014 15:54:19 Grant Likely wrote:
> > On Wed, 12 Feb 2014 11:20:00 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> > > On Wed, Feb 12, 2014 at 12:45:54PM -0500, Jason Cooper wrote:
> > > 
> > > > The bootloader would then load this file into ram, and pass the
> > > > address/size to the kernel either via dt, or commandline.  kaslr (run in
> > > > the decompressor) would consume some of this randomness, and then
> > > > random.c would consume the rest in a non-crediting initialization.
> > > 
> > > Sure is a neat idea, but I think in general it would probably be smart
> > > to include the entire FDT blob in the early random pool, that way you
> > > get MACs and other machine unique data too.
> > 
> > I applied a patch that did exactly that (109b623629), and then reverted
> > it (b920ecc82) shortly thereafter because add_device_randomness() is
> > a rather slow function and FDTs can get large. I'd like to see someone
> > do a reasonable analysis on the cost of using an FDT for randomness
> > before I reapply a patch doing something similar. An awful lot of the
> > FDT data is not very random, but there are certainly portions of it that
> > are appropriate for the random pool.
> 
> Could we use a faster hash function that scans the entire device tree and
> then just feed the output of that into add_device_randomness? We probably
> can't expect that there is a lot of entropy in the DT blob, so the
> result wouldn't be all that different in terms of quality of the random
> seed.
> 
> 	Arnd

Yes, I think that is a good solution.

g.

