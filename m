Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaBRSCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:02:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaBRSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:02:32 -0500
Date: Tue, 18 Feb 2014 10:03:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/11 RESEND] mei: add mei_hbuf_acquire wrapper
Message-ID: <20140218180357.GA15274@kroah.com>
References: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
 <1392642807-8878-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392642807-8878-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 03:13:17PM +0200, Tomas Winkler wrote:
> A client has to acquire host buffer
> before writing, we add lock like wrapper
> to replace the code snippet
> 
> if (dev->hbuf_is_ready)
>         dev->hbuf_is_ready = false;
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/amthif.c    |  7 +-----
>  drivers/misc/mei/client.c    | 56 ++++++++++++++++++++++++++++----------------
>  drivers/misc/mei/hw-me.c     |  2 ++
>  drivers/misc/mei/hw-txe.c    | 17 +++++---------
>  drivers/misc/mei/interrupt.c |  6 ++---
>  drivers/misc/mei/mei_dev.h   |  2 ++
>  drivers/misc/mei/wd.c        | 14 +++++------
>  7 files changed, 57 insertions(+), 47 deletions(-)

This patch fails to apply to my char-misc-next branch (I've pulled in
3.14-rc3 into this branch now):
	checking file drivers/misc/mei/amthif.c
	checking file drivers/misc/mei/client.c
	Hunk #4 FAILED at 681.
	Hunk #5 succeeded at 815 (offset -2 lines).
	Hunk #6 succeeded at 848 (offset -2 lines).
	1 out of 6 hunks FAILED
	checking file drivers/misc/mei/hw-me.c
	checking file drivers/misc/mei/hw-txe.c
	checking file drivers/misc/mei/interrupt.c
	checking file drivers/misc/mei/mei_dev.h
	checking file drivers/misc/mei/wd.c

Care to fix this up and resend this series?

thanks,

greg k-h
