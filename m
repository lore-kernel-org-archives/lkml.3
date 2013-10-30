Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3J3RjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:39:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3J3RjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:39:06 -0400
Date: Wed, 30 Oct 2013 10:39:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
Message-ID: <20131030173905.GE20147@kroah.com>
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
> + * GenWQE Driver: Need SLC timeout set to 250ms (temporary setting for
> + * testing of 1000ms due to decompressor testcase failing)
> + *
> + * There is a requirement by the card users that the timeout must not
> + * exceed the 250ms.
> + *
> + * In this case the settings must be done before any interaction to
> + * the device can be done, since we cannot change the settings without
> + * stopping the queues.

Then stop the queue, change the value, and start them up again.

Why would anyone ever want to change these values?  Don't make anything
"tunable", just get it right and don't rely on someone making tweaks
later with module options, especially as, again, these are driver wide,
not specific to a device.

If you _really_ need them for a device, make them a sysfs file and fix
the code to handle stopping and starting.  You have to handle that
anyway with dynamic bind/unbind of the driver to specific devices
anyway, so this shouldn't be a big deal.

greg k-h
