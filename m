Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaBQSXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:23:30 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33771 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752436AbaBQSX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:23:26 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19w/NnXVPj3SD5eQVV5ur6M+R6BPVAjXlo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7AD2C52A7A4
Date: Mon, 17 Feb 2014 13:23:12 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        devicetree@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Message-ID: <20140217182312.GV7862@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
 <201402121251.06280.arnd@arndb.de>
 <20140217155419.682F7C401D4@trevor.secretlab.ca>
 <1418981.0py7JxXCp8@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418981.0py7JxXCp8@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 05:13:07PM +0100, Arnd Bergmann wrote:
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

I think it would be easier to identify the few attributes that differ
from board to board (mac address, serial number, etc), and differ from
boot to boot (random-seed, timestamp) and just extract and feed those
in.

We already have the fdt parsing code in the decompressor...

thx,

Jason.
