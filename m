Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab3A1Ood (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:44:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:58758 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab3A1Ooa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:44:30 -0500
Date: Mon, 28 Jan 2013 06:46:15 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Millenbach <jmillenbach@gmail.com>,
        Brian Swetland <swetland@google.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Bruce Beare <bruce.j.beare@intel.com>,
        Tom Keel <thomas.keel@intel.com>, Alan Cox <alan@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the tty tree with the input tree
Message-ID: <20130128144615.GC2997@kroah.com>
References: <20130128204424.a3eedfee954ba6cc7a620652@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128204424.a3eedfee954ba6cc7a620652@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 08:44:24PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/input/keyboard/Kconfig between commit 6f2ac009f29b ("Input:
> goldfish - virtual input event driver") from the input tree and commit
> 4f73bc4dd3e8 ("tty: Added a CONFIG_TTY option to allow removal of TTY")
> from the tty tree.
> 
> I fixed it up (see below - I am not sure if GOLDFISH_EVENTS needs TTY or
> not) and can carry the fix as necessary (no action is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/input/keyboard/Kconfig
> index 078305e,008f96a..0000000
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@@ -479,16 -482,8 +482,18 @@@ config KEYBOARD_SAMSUN
>   	  To compile this driver as a module, choose M here: the
>   	  module will be called samsung-keypad.
>   
> + if TTY
> + 
>  +config KEYBOARD_GOLDFISH_EVENTS
>  +	depends on GOLDFISH
>  +	tristate "Generic Input Event device for Goldfish"
>  +	help
>  +	  Say Y here to get an input event device for the Goldfish virtual

Looks good, thanks.

greg k-h
