Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaJCQgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:36:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaJCQgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:36:01 -0400
Date: Fri, 3 Oct 2014 09:35:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        fabio.falzoi84@gmail.com
Subject: Re: [PATCH v3] staging: rts5208: Clean up coding style in rtsx_chip.c
Message-ID: <20141003163559.GA12903@kroah.com>
References: <542ECBCD.3050209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542ECBCD.3050209@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 07:16:13PM +0300, Giedrius Statkevicius wrote:
> Make the second line of a divided line match the opening paranthesis.
> Combine two if's in form of 'if (a) if (b) { [...] }' into one to lower the indentation level.
> To further lower indentation level and make the code more concise use the ternary operator where possible and sensible.
> Make the names of labels all lower case to avoid Camel Case.
> Remove unnecessary parantheses around variables that are after a dereference operator i.e. &(a) => &a
> Switch the if condition around in 'if (0 == (value & (1 << bit))) {' to make it have the same form as the rest of the code.
> Remove unnecessary braces in rtsx_enable_aspm() around one statement
> 
> After this patch checkpatch.pl without --strict doesn't complain about rtsx_chip.c at all and with --strict it only complains about the unmatched parantheses.
> I am reluctant to move that code with unmatched parantheses into another function because I don't have the hardware needed to test this driver and don't have
> enough experience to do it properly. Doing so would just probably hide the other problems this code has. My patch should be purely about changing the code style without
> creating more functions and moving code to them. 
> 
> This patch is against Greg KH's staging-next tree.
> 
> Signed-off-by: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>

That is a _lot_ to do in just one patch (also note you should wrap your
changelog text at 72 characters, like git asked you to...)

Please break this up into small, logical patches, each only doing one
thing.  Trying to review a large patch like this is almost impossible.

thanks,

greg k-h
