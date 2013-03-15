Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3COUaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:30:15 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60725 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3COUaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:30:13 -0400
Date: Fri, 15 Mar 2013 13:30:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/serial: Fix uninitialized variable warning
Message-ID: <20130315203010.GA25081@kroah.com>
References: <1362360907-4439-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362360907-4439-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 09:35:07AM +0800, Grant Likely wrote:
> drivers/tty/serial/8250/8250.c: In function 'serial_unlink_irq_chain':
> drivers/tty/serial/8250/8250.c:1676:19: warning: 'i' may be used uninitialized in this function
> 
> There isn't an actual bug here since the function tests the condition
> that would cause i to be uninitialized before dereferencing i. However,
> at least some versions of GCC complain as shown above. (in my case,
> powerpc gcc 2.5.2). Initializing i to NULL makes it clear to GCC and the
> casual code reviewer that i will not be dereferenced to a random
> address.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Greg, some may argue that this is a tool problem, not a kernel problem,
> but it is useful to me. If anyone objects I'm not going to spend any
> time championing for this patch.

Upgrade your tools to ones that work properly :)

greg k-h
