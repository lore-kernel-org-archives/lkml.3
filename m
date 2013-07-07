Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3GGA24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 20:28:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3GGA2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 20:28:54 -0400
Date: Sat, 6 Jul 2013 17:29:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, linux-driver@qlogic.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: qlcnic binary sysfs file abuse
Message-ID: <20130707002949.GA15822@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was doing a kernel-wide audit on all of the binary sysfs files, and
noticed a metric ton of them in the qlcnic driver.

The rules about binary sysfs files are that they can not be touched by
the kernel at all, they are "pass-through" directly to the hardware, and
it seems that this driver is not doing that properly.

It also seems that almost all of these files are merely "debugging"
files, but as I can't seem to find the relevant Documentation/ABI/
documentation for them, I can't be sure.

So, any objection to me just deleting these entirely?  Or, if they
really are needed, can I just move them to debugfs, which is where I
think they should have been from the beginning?

Oh, and I'm pretty sure that the creation of these is totally racy, so I
really doubt that anyone is using them otherwise they would have noticed
this already.

thanks,

greg k-h
