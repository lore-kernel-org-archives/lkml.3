Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaBLSwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:52:14 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18738 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753216AbaBLSwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:52:11 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19z+qI5kPu/tjxTSoGoxNmlwddCe8CTarw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3981B525D7F
Date: Wed, 12 Feb 2014 13:51:56 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: devicetree@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        keescook@chromium.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Message-ID: <20140212185156.GP27395@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
 <201402121251.06280.arnd@arndb.de>
 <20140212174554.GM27395@titan.lakedaemon.net>
 <20140212182000.GJ5554@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212182000.GJ5554@obsidianresearch.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:20:00AM -0700, Jason Gunthorpe wrote:
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

Sure.

> From there it is a small step to encourage bootloaders to include
> boot-time-variable data in the DT like like 'boot time of day', 'cycle
> counter', 'random blob', etc.

I like it.

> Then you just need the bootloader to dump the random-seed file into a
> DT property.

Yes, see my response to Arnd re the binding.  I'm also interested in
making it easier for devices already in the field.  iow, without
upgrading the bootloader.

> Or have the bootloader fetch randomness from any HWRNG it has a driver
> for. (eg a TPM)

Depends on who you're protecting against.  I'd prefer to have that
called out as a separate blob in the DT so the kernel could decide
whether to trust it explicitly, or mix it like random.c already does
with RDRAND.

thx,

Jason.
