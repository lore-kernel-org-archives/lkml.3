Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965265Ab3BMSQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:16:36 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:37132 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965013Ab3BMSQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:16:31 -0500
Date: Wed, 13 Feb 2013 10:16:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Spelvin <linux@horizon.com>
Cc: linux-serial@vger.kernel.org, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org, giometti@linux.it
Subject: Re: [PATCH v2 5/9] pps: Move timestamp read into PPS code proper
Message-ID: <20130213181628.GA17367@kroah.com>
References: <cover.1360677367.git.linux@horizon.com>
 <31e24f360b1715c262c05d6708353e292640b3a8.1360677367.git.linux@horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31e24f360b1715c262c05d6708353e292640b3a8.1360677367.git.linux@horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 02:00:43AM -0500, George Spelvin wrote:
> The PPS (Pulse-Per-Second) line discipline has developed a number of
> unhealthy attachments to core tty data and functions, ultimately leading
> to its breakage.
> 
> The previous patches fixed the crashing.  This one reduces coupling further
> by eliminating the timestamp parameter from the dcd_change ldisc method.
> This reduces header file linkage and makes the extension more generic,
> and the timestamp read is delayed only slightly, from just before the
> ldisc->ops->dcd_change method call to just after.
> 
> Fix attendant build breakage in
>     drivers/tty/n_tty.c
>     drivers/tty/tty_buffer.c
>     drivers/staging/speakup/selection.c

I also had to fix up:
	drivers/staging/dgrp/dgrp_*.c

to get things to build properly.

thanks,

greg k-h
