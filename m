Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab3HBKgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:36:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3HBKge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:36:34 -0400
Date: Fri, 2 Aug 2013 18:37:44 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andreas =?iso-8859-1?Q?Bie=DFmann?= <andreas@biessmann.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org
Subject: Re: [RESEND][PATCH v2] register_console: prevent adding the same
 console twice
Message-ID: <20130802103744.GA6356@kroah.com>
References: <1364201964-2990-1-git-send-email-andreas@biessmann.de>
 <1375439014-13679-1-git-send-email-andreas@biessmann.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375439014-13679-1-git-send-email-andreas@biessmann.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 12:23:34PM +0200, Andreas Bieﬂmann wrote:
> This patch guards the console_drivers list to be corrupted. The
> for_each_console() macro insist on a strictly forward list ended by NULL:
> 
>  con0->next->con1->next->NULL
> 
> Without this patch it may happen easily to destroy this list for example by
> adding 'earlyprintk' twice, especially on embedded devices where the early
> console is often a single static instance.  This will result in the following
> list:
> 
>  con0->next->con0
> 
> This in turn will result in an endless loop in console_unlock() later on by
> printing the first __log_buf line endlessly.
> 
> Signed-off-by: Andreas Bieﬂmann <andreas@biessmann.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@vger.kernel.org

It's a nice "feature", but I fail to see how this is worthy of going
into the stable tree, as it's not fixing a kernel error, only a typo by
a user.

thanks,

greg k-h
