Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaAHXYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:24:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbaAHXYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:24:07 -0500
Date: Wed, 8 Jan 2014 15:24:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc 3/4] mei: revamp mei reset state machine
Message-ID: <20140108232437.GB11300@kroah.com>
References: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
 <1389205164-13553-4-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389205164-13553-4-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 08:19:23PM +0200, Tomas Winkler wrote:
> 1. MEI_DEV_RESETTING device state spans only hardware reset flow
> while starting dev state is saved into a local variable for further
> reference, this let us to reduce big if statements in case we
> are trying to avoid nested resets
> 
> 2. During initializations if the reset ended in MEI_DEV_DISABLED device
> state we bail out with -ENODEV
> 
> 3. Remove redundant interrupts_enabled parameter as this
>  can be deduced from the starting dev_state
> 
> 4. mei_reset propagates error code to the caller
> 
> 5. Add mei_restart function to wrap the pci resume
> 
> Cc: <stable@vger.kernel.org> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> ---
>  drivers/misc/mei/hbm.c       |   2 +-
>  drivers/misc/mei/hw-me.c     |  10 +--
>  drivers/misc/mei/init.c      | 210 ++++++++++++++++++++++++++-----------------
>  drivers/misc/mei/interrupt.c |  13 +--
>  drivers/misc/mei/mei_dev.h   |   3 +-
>  drivers/misc/mei/pci-me.c    |  10 +--
>  6 files changed, 143 insertions(+), 105 deletions(-)

Again, way too big for stable kernels, sorry.

greg k-h
