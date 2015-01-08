Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbbAHOOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:14:20 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:55565 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbbAHOOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:14:19 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20141223175803.GA9789@zzz>
References: <20141223175803.GA9789@zzz>
Date: Thu, 8 Jan 2015 15:14:18 +0100
Message-ID: <CAJfpegtqBEZLdhKjXe3VhZe5mp1LvsQRTOjHw3RcnWeqi+U6NA@mail.gmail.com>
Subject: Re: [fuse-devel] [BUG] fuse: request prepared before protocol version
 is known
From: Miklos Szeredi <miklos@szeredi.hu>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 6:58 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> I am using Linux 3.19-rc1 and I encountered a bug where stat() would
> sporatically fail with EIO when called on a file in a FUSE filesystem very
> shortly after that filesystem has been mounted.  This is a regression caused by
> commit 7078187a: "fuse: introduce fuse_simple_request() helper".
>
> The underlying issue is that the arguments to the FUSE request are being
> initialized before the protocol version (fc->minor) is known.  This was not a
> problem with the old code because fuse_get_req() will wait until the channel has
> been initialized.
>
> The only potential solutions I have in mind are adding an explicit waits in all
> the needed places, or reverting the commit.

Thanks for the report.  See for-linus branch of

 git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

for the fix.

Thanks,
Miklos
