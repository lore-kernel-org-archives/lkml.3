Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3FZPrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:47:04 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49383 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZPrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:47:02 -0400
Date: Wed, 26 Jun 2013 17:46:56 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sedat.dilek@gmail.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: Tree for Jun 26 [ vfs | block | fuse (cpuidle)
 releated? ]
Message-ID: <20130626174656.6d9e2d2a@skate>
In-Reply-To: <20130626153236.GA29455@kroah.com>
References: <CA+icZUWDDCsXBK4+s4fEbM_AGj3EnfCRAe2=yE+8_MT4mauPXg@mail.gmail.com>
	<CA+icZUXtTxVUfOmFak9GzyUdGa7bBuxTr2CJEY0vNn0bH2-4Vw@mail.gmail.com>
	<20130626172446.51f0bd5f@skate>
	<20130626153236.GA29455@kroah.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg Kroah-Hartman,

On Wed, 26 Jun 2013 08:32:36 -0700, Greg Kroah-Hartman wrote:

> > Ok. My understanding is that the misc device registered by
> > fs/fuse/dev.c:fuse_dev_init() makes the assumption that
> > file->private_data == NULL when a misc device is opened. But I'm not
> > sure to fully understand the code flow of the FUSE filesystem.
> > 
> > And since it doesn't provide its own implementation of the ->open()
> > operation, the misc infrastructure was leaving the file->private_data
> > defined to NULL before my patch.
> > 
> > With my patch, the file->private_data gets assigned unconditionally
> > (regardless of whether the misc driver provides or does not provide a
> > ->open() operation) which modifies the unwritten assumption that fuse
> > was making about the initial value of file->private_data. I believe the
> > assumption made by fuse over the initial value of this variable is a
> > bit fragile.
> > 
> > Maybe the FUSE code needs to be slightly adjusted to not make this
> > assumption?
> 
> As the FUSE code was working properly before this change, I think this
> misc core change needs to be reverted, so I'll go do that in a bit.

Yes, sure, that's the right immediate action to take.

Long term, I believe the FUSE code seems to be making a fragile
assumption, and that might require some additional investigation.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
