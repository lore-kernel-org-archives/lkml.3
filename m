Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3FYJ7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:59:48 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41403 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3FYJ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:59:47 -0400
Date: Tue, 25 Jun 2013 11:59:44 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Samu Onkalo <samu.p.onkalo@nokia.com>,
        michael.opdenacker@free-electrons.com,
        gregory.clement@free-electrons.com, maxime.ripard@free-electrons.com,
        alexandre.belloni@free-electrons.com
Subject: Re: [PATCH] char: misc: assign file->private_data in all cases
Message-ID: <20130625115944.28fc447b@skate>
In-Reply-To: <20130624222642.GA24099@kroah.com>
References: <1371819665-3882-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<20130624222642.GA24099@kroah.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg Kroah-Hartman,

On Mon, 24 Jun 2013 15:26:42 -0700, Greg Kroah-Hartman wrote:

> > However, this assignment was only done when the misc driver was
> > declaring a driver-specific ->open() operation in its
> > file_operations. This doesn't make sense, as the driver may not
> > necessarily have a custom ->open() operation, and might still be
> > interested in having file->private_data properly set for use in its
> > ->read() and write() operations.
> > 
> > Therefore, we move the assignment of file->private_data outside of the
> > condition that tests whether a driver-specific ->open() operation was
> > defined.
> 
> Does this solve a problem with an existing misc driver?  Or are you just
> trying to be "safe" for future, broken, drivers?

This problem was spotted while implementing a dummy/example misc driver
for training purposes. I am not aware of any mainline misc driver
affected by this problem, but I haven't reviewed all misc drivers.

It simply seems to make sense to implement the feature of fa1f68db6ca
("drivers: misc: pass miscdevice pointer via file private data") in a
way that also allows misc drivers that do not provide their own
->open() operation to use it.

That said, I'm not sure why you call such drivers 'broken'.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
