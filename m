Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3G2UJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:09:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3G2UJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:09:15 -0400
Date: Mon, 29 Jul 2013 13:09:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 1/2] uio: provide vm access to UIO_MEM_PHYS maps
Message-ID: <20130729200914.GA6146@kroah.com>
References: <20130727214911.GK1754@pengutronix.de>
 <1374962978-1860-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374962978-1860-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 12:09:37AM +0200, Uwe Kleine-König wrote:
> This makes it possible to let gdb access mappings of the process that is
> being debugged.
> 
> uio_mmap_logical was moved and uio_vm_ops renamed to group related code
> and differentiate to new stuff.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Changes since v1:
>     - only use generic_access_phys ifdef CONFIG_HAVE_IOREMAP_PROT
>     - fix all users of renamed struct

I still get a build error with this patch:

  MODPOST 384 modules
ERROR: "generic_access_phys" [drivers/uio/uio.ko] undefined!

So something isn't quite right.

greg k-h
