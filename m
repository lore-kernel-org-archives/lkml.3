Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaAHXXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:23:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbaAHXXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:23:40 -0500
Date: Wed, 8 Jan 2014 15:24:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc 1/4] mei: do not run reset flow from the interrupt
 thread
Message-ID: <20140108232410.GA11300@kroah.com>
References: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
 <1389205164-13553-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389205164-13553-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 08:19:21PM +0200, Tomas Winkler wrote:
> This fixes a potential deadlock in case of a firmware
> initiated reset
> 
> mei_reset has a dialog with the interrupt thread hence
> it has to be run from an another work item
> 
> Most of the mei_resets were called from mei_hbm_dispatch
> which is called in interrupt thread context so this
> function underwent major revamp. The error code is
> propagated to the interrupt thread and if needed
> the reset is scheduled from there.
> 
> Cc: <stable@vger.kernel.org> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> ---
>  drivers/misc/mei/hbm.c       | 200 +++++++++++++++++++++++++++----------------
>  drivers/misc/mei/hbm.h       |   6 +-
>  drivers/misc/mei/hw-me.c     |  32 ++++---
>  drivers/misc/mei/init.c      | 100 +++++++++++++---------
>  drivers/misc/mei/interrupt.c |   9 +-
>  drivers/misc/mei/mei_dev.h   |   1 +
>  6 files changed, 210 insertions(+), 138 deletions(-)

This is a _really_ big patch for a stable kernel tree.  Are you sure
it's needed there?  Please go read Documentation/stable_kernel_rules.txt
again.

greg k-h
