Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3AVRks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:40:48 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:59542 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3AVRkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:40:47 -0500
Date: Tue, 22 Jan 2013 09:40:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 01/33] lib: devres: Introduce devm_ioremap_resource()
Message-ID: <20130122174043.GA1411@kroah.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-2-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358762966-20791-2-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:08:54AM +0100, Thierry Reding wrote:
> The devm_request_and_ioremap() function is very useful and helps avoid a
> whole lot of boilerplate. However, one issue that keeps popping up is
> its lack of a specific error code to determine which of the steps that
> it performs failed. Furthermore, while the function gives an example and
> suggests what error code to return on failure, a wide variety of error
> codes are used throughout the tree.
> 
> In an attempt to fix these problems, this patch adds a new function that
> drivers can transition to. The devm_ioremap_resource() returns a pointer
> to the remapped I/O memory on success or an ERR_PTR() encoded error code
> on failure. Callers can check for failure using IS_ERR() and determine
> its cause by extracting the error code using PTR_ERR().
> 
> devm_request_and_ioremap() is implemented as a wrapper around the new
> API and return NULL on failure as before. This ensures that backwards
> compatibility is maintained until all users have been converted to the
> new API, at which point the old devm_request_and_ioremap() function
> should be removed. To help prevent new users from being added in the
> meantime, devm_request_and_ioremap() is marked __deprecated.

I've edited the patch and removed the __depreciated line as that's just
going to cause a whole lot of noise in the kernel.  I'd recommend just
watching to ensure that we catch all users of the current function and
convert them to the new one, and then we can drop it, no need to use
__deprecated at all.

thanks,

greg k-h
