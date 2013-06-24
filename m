Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060Ab3FXW0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:26:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3FXW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:26:44 -0400
Date: Mon, 24 Jun 2013 15:26:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Samu Onkalo <samu.p.onkalo@nokia.com>,
        michael.opdenacker@free-electrons.com,
        gregory.clement@free-electrons.com, maxime.ripard@free-electrons.com,
        alexandre.belloni@free-electrons.com
Subject: Re: [PATCH] char: misc: assign file->private_data in all cases
Message-ID: <20130624222642.GA24099@kroah.com>
References: <1371819665-3882-1-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371819665-3882-1-git-send-email-thomas.petazzoni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 03:01:05PM +0200, Thomas Petazzoni wrote:
> In fa1f68db6ca ("drivers: misc: pass miscdevice pointer via file
> private data"), the misc driver infrastructure was changed to assigned
> file->private_data as a pointer to the 'struct miscdevice' that
> corresponds to the device being opened.
> 
> However, this assignment was only done when the misc driver was
> declaring a driver-specific ->open() operation in its
> file_operations. This doesn't make sense, as the driver may not
> necessarily have a custom ->open() operation, and might still be
> interested in having file->private_data properly set for use in its
> ->read() and write() operations.
> 
> Therefore, we move the assignment of file->private_data outside of the
> condition that tests whether a driver-specific ->open() operation was
> defined.

Does this solve a problem with an existing misc driver?  Or are you just
trying to be "safe" for future, broken, drivers?

thanks,

greg k-h
