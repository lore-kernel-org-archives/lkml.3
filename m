Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3A1Rdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:33:41 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46858 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3A1Rdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:33:37 -0500
Date: Mon, 28 Jan 2013 09:33:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Millenbach <jmillenbach@gmail.com>,
        Brian Swetland <swetland@google.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Bruce Beare <bruce.j.beare@intel.com>,
        Tom Keel <thomas.keel@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: manual merge of the tty tree with the input tree
Message-ID: <20130128173330.GA11769@core.coreip.homeip.net>
References: <20130128204424.a3eedfee954ba6cc7a620652@canb.auug.org.au>
 <20130128144615.GC2997@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128144615.GC2997@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 06:46:15AM -0800, Greg KH wrote:
> On Mon, Jan 28, 2013 at 08:44:24PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the tty tree got a conflict in
> > drivers/input/keyboard/Kconfig between commit 6f2ac009f29b ("Input:
> > goldfish - virtual input event driver") from the input tree and commit
> > 4f73bc4dd3e8 ("tty: Added a CONFIG_TTY option to allow removal of TTY")
> > from the tty tree.
> > 
> > I fixed it up (see below - I am not sure if GOLDFISH_EVENTS needs TTY or
> > not) and can carry the fix as necessary (no action is required).
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc drivers/input/keyboard/Kconfig
> > index 078305e,008f96a..0000000
> > --- a/drivers/input/keyboard/Kconfig
> > +++ b/drivers/input/keyboard/Kconfig
> > @@@ -479,16 -482,8 +482,18 @@@ config KEYBOARD_SAMSUN
> >   	  To compile this driver as a module, choose M here: the
> >   	  module will be called samsung-keypad.
> >   
> > + if TTY
> > + 
> >  +config KEYBOARD_GOLDFISH_EVENTS
> >  +	depends on GOLDFISH
> >  +	tristate "Generic Input Event device for Goldfish"
> >  +	help
> >  +	  Say Y here to get an input event device for the Goldfish virtual
> 
> Looks good, thanks.

Greg,

Please drop 4f73bc4dd3e8563ef4109f293a092820dff66d92, at least the parts
related to input. As far as I know nothing except serport driver
depends on tty and we do not need to introduce this kind of
dependencie. Anyone needing slim config can simply try disabling
input (or parts of it) without needing an artificial dependencies.

Thanks.

-- 
Dmitry
