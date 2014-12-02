Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaLBR0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:26:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLBR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:26:13 -0500
Date: Tue, 2 Dec 2014 09:26:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Richard Yao <ryao@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Why not make kdbus use CUSE?
Message-ID: <20141202172612.GA8958@kroah.com>
References: <20141129063416.GE32286@woodpecker.gentoo.org>
 <20141129175947.GB32510@kroah.com>
 <547D50B9.9040909@gentoo.org>
 <20141202054850.GA17043@kroah.com>
 <547D7159.2040900@gentoo.org>
 <547DAEF3.1090106@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547DAEF3.1090106@gentoo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 07:22:11AM -0500, Richard Yao wrote:
> Assuming that this dance succeeds, the FUSE process could then make a
> readonly file in itself, open it read only, unlink it, put the data into
> the file and send the file descriptor via UNIX domain socket while
> refusing further writes. If it has its own user/group, the file should
> be safe from prying eyes.
> 
> This is not as good as a memfd and also suffers from the race that
> O_TMPFILE was meant to close, but it should be able to function as a
> decent fallback.

We can't knowingly create and advocate for broken code, sorry.

> This would preserve portability across not only
> different versions of Linux, but also other POSIX systems.

I honestly do not care about any other system than Linux, so I don't see
why this would ever be an issue.

> Keeping the code in userspace would allow us to apply SELinux policies
> to it, which is something that we would lose if it were go to into the
> kernel.

On the contrary, the kdbusfs implementation gives you better security
model support than before, it ties directly into the LSM hooks, see the
add-on patches from some other developers that bring full support of LSM
to the codebase.

> That said, it is still not clear to me that dbus must be inside the
> kernel to be able to perform multicast and zero copy using memfd.

It seems you have yet to read my introductory email for the patch
series.

greg k-h
