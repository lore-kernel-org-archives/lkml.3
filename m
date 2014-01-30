Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaA3N1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:27:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaA3N1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:27:17 -0500
Date: Thu, 30 Jan 2014 05:28:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: handle out-of-bounds read/write
Message-ID: <20140130132827.GA22557@kroah.com>
References: <20140130094802.4ee29435@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130094802.4ee29435@hananiah.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 09:48:02AM +0100, Petr Tesarik wrote:
> The loff_t type may be wider than phys_addr_t (e.g. on 32-bit systems).
> Consequently, the file offset may be truncated in the assignment.
> Currently, /dev/mem wraps around, which may cause applications to read
> or write incorrect regions of memory by accident.

Does that really happen?  If so, that's a userspace bug, right?

> Let's follow POSIX file semantics here and return 0 when reading from
> and -EFBIG when writing to an offset that cannot be represented by a
> phys_addr_t.
> 
> Note that the conditional is optimized out by the compiler if loff_t
> has the same size as phys_addr_t.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> ---
>  drivers/char/mem.c | 6 ++++++
>  1 file changed, 6 insertions(+)

What is going to break if we apply this patch?  :)

thanks,

greg k-h
