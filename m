Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab3J3RhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:37:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3J3RhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:37:23 -0400
Date: Wed, 30 Oct 2013 10:37:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
Message-ID: <20131030173722.GD20147@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 10:32:58AM +0100, Frank Haverkamp wrote:
> +/*
> + * We like to be able to disable the health checking entirely in some
> + * cases e.g. if a card is broken and needs to be analyzed. I
> + * considered using debugfs/sysfs attributes, but I did not see a way
> + * to prevent the thread from being started at driver load time other
> + * than starting it later manually, what I did not like either
> + * in this case (e.g. like the new SRIOV enablement).
> + */
> +static int genwqe_health_check_interval = 4;   /* <= 0: disabled */
> +module_param(genwqe_health_check_interval, int, 0644);  /* read/writeable */
> +MODULE_PARM_DESC(genwqe_health_check_interval,
> +		 "check card health every N seconds (0 = disabled)");

Module paramaters are driver wide, not device specific.

If a card is broken, it's broken, send it back.  No one will ever know
to set this value, and then you just affected all other cards in the
system for this same driver.

Just delete this please.

thanks,

greg k-h
