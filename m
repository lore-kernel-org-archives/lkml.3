Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3EQVxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:53:05 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35539 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab3EQVwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:52:50 -0400
Date: Fri, 17 May 2013 14:52:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regmap and register ranges
Message-ID: <20130517215246.GA24730@core.coreip.homeip.net>
References: <1657392.sx3qBqNYrh@dtor-d630.eng.vmware.com>
 <20130517205025.GQ1627@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517205025.GQ1627@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 09:50:25PM +0100, Mark Brown wrote:
> On Fri, May 17, 2013 at 09:24:30AM -0700, Dmitry Torokhov wrote:
> 
> > I am looking at regmap and I wonder if I am missing something with the
> > way it checks if a window crosses another range boundary or if a
> > selector is in some other window as it seem to be always tripping on
> > itself. Should we skip the current range as we iterate through them
> > and do sanity checks? 
> 
> > The setup: a device with 0x0000 - 0xffff potential register range, paged
> > in chunks of 256 registers with page selector register repeated at 0xff.
> 
> The general idea is that the pages should be mapped in to virtual
> addresses rather than real ones so in your example you might add a
> prefix so all the registers are numbered 0x10000 to 0x1ffff.  The
> physical registers and the ones inside the paged range aren't supposed
> to overlap.

The issue I have with doing an arbitrary offset is that then data
exposed in debugfs does not match the data from device's specification.

> 
> We should probably either do sanity checks for this at init time or come
> up with a sensible way to support this in case someone does decide to do
> it, though this is the first time anyone noticed.

Does this mean you'll be open to patches allowing this scenario?

Thanks.

-- 
Dmitry
