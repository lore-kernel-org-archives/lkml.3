Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab3FAFM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 01:12:29 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39998 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3FAFMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 01:12:23 -0400
Date: Fri, 31 May 2013 22:12:23 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Clark <robclark@gmail.com>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH v2] video: simplefb: add mode parsing function
Message-ID: <20130601051223.GB5189@quad.lixom.net>
References: <1369626821-28494-1-git-send-email-acourbot@nvidia.com>
 <51A42ED5.2060104@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A42ED5.2060104@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 10:13:09PM -0600, Stephen Warren wrote:
> On 05/26/2013 09:53 PM, Alexandre Courbot wrote:
> > The naming scheme of simplefb's mode is precise enough to allow building
> > the mode structure from it instead of using a static list of modes. This
> > patch introduces a function that does this. In case exotic modes that
> > cannot be represented from their name alone are needed, the static list
> > of modes is still available as a backup.
> > 
> > It also changes the order in which colors are declared from MSB first to
> > the more standard LSB first.
> > 
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > ---
> > Changes from v1:
> > - amended documentation following Stephen's suggestion
> > - allow parsing of bitfields larger than 9 bits
> > - made it clear that the parsing order of bits is changed with respect
> >   to the original patch
> > 
> > Andrew, since this patch introduces a (small) change in the DT bindings,
> > could we try to merge it during the -rc cycle so we don't have to come
> > with a more complex solution in the future?
> 
> So, I think we shouldn't change the DT binding at all now. The original
> driver is now merged for 3.10, and I think it's far too late to take
> code that implements new features for 3.10. This means that we couldn't
> merge this patch until 3.11. However, by then, we shouldn't be changing
> the DT binding in incompatible ways. Olof has already published some
> U-Boot binaries that use the current binding, and on IRC indicated he'd
> prefer not to change the binding because of that.
> 
> As such, we should either:
> 
> a) Just add new entries into the format array that already exists in the
> driver. Given David's response, this might be simplest.

I think so too. Is this even needed? Do we have any users of the newer formats
or is it just someone trying to feature-creep this driver to make the "simple"
part of the name inaccurate? :)

> b) Extend the DT binding in a 100% backwards-compatible way, which would
> mean defaulting the bit-order to match the existing 1 format, and adding
> a new Boolean property to indicate that the format string is specified
> in the other order.

Or just add a new property that has higher priority for the newer format
strings, and make the driver use that if it exists, otherwise fall back.


-Olof
